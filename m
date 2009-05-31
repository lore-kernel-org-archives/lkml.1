Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZEaOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZEaOiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbZEaOiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:38:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36716 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbZEaOip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:38:45 -0400
Message-ID: <4A22965A.6030201@redhat.com>
Date: Sun, 31 May 2009 10:38:18 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: "Larry H." <research@subreption.com>
CC: linux-kernel@vger.kernel.org, pageexec@freemail.hu, linux-mm@kvack.org,
       Linus Torvalds <torvalds@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and key/iv
 handling
References: <20090531025720.GC9033@oblivion.subreption.com>
In-Reply-To: <20090531025720.GC9033@oblivion.subreption.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry H. wrote:
> [PATCH] Use kzfree in crypto API context initialization and key/iv handling
> 
> This patch replaces the kfree() calls within the crypto API (algorithms,
> key setup and handling, etc) with kzfree(), to enforce sanitization of
> the allocated memory.
> 
> This prevents such information from persisting on memory and eventually
> leak to other kernel users or during coldboot attacks.
> 
> This patch replaces kfree() for context (algorithm meta-data) structures
> too. Those are initialized or released once, and remain in use during the
> lifetime of the cipher/algorithm instance, therefore no performance impact
> exists for those specific changes.
> 
> This patch doesn't affect fastpaths.
> 
> Signed-off-by: Larry Highsmith <research@subreption.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
