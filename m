Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYLaVab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYLaVab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 16:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbYLaVaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 16:30:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52132 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYLaVaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 16:30:20 -0500
Message-ID: <495BE45A.2000900@redhat.com>
Date: Wed, 31 Dec 2008 16:30:02 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Peter W Morreale <pmorreale@novell.com>
CC: akpm@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, spamtrap@knobisoft.de
Subject: Re: [PATCH 1/2] Fix pdflush thread creation upper bound.
References: <20081231190755.30792.24205.stgit@hermosa.site> <20081231191011.30792.17202.stgit@hermosa.site>
In-Reply-To: <20081231191011.30792.17202.stgit@hermosa.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W Morreale wrote:
> This patch fixes a race on creating pdflush threads.  Without the patch,
> it is possible to create more than MAX_PDFLUSH_THREADS threads, and this
> has been observed in practice on IO loaded SMP machines.

> 
> Signed-off-by: Peter W Morreale <pmorreale@novell.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
