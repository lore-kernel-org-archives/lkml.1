Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYIOTNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYIOTNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYIOTNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:13:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35472 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYIOTNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:13:35 -0400
Message-ID: <48CEB312.2070500@cs.helsinki.fi>
Date: Mon, 15 Sep 2008 22:10:10 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix declaration of cgroup_mm_owner_callbacks
References: <20080915190638.99E613D6952@localhost>
In-Reply-To: <20080915190638.99E613D6952@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Fix declaration of cgroup_mm_owner_callbacks()
> 
> The choice of real/dummy declaration for cgroup_mm_owner_callbacks()
> shouldn't be based on CONFIG_MM_OWNER, but on
> CONFIG_CGROUPS. Otherwise kernel/exit.c fails to compile when
> something other than a cgroups controller selects CONFIG_MM_OWNER
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
> 
> This is a retry with a mailer that hopefully didn't break the
> whitespace formatting

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
