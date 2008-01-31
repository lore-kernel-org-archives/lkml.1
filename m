Return-Path: <linux-kernel-owner+w=401wt.eu-S1765259AbYAaP5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765259AbYAaP5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYAaP5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:57:31 -0500
Received: from www.tglx.de ([62.245.132.106]:47565 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbYAaP5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:57:30 -0500
Date: Thu, 31 Jan 2008 16:57:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/9] GBPAGES: Split LARGE_PAGE_SIZE/MASK into
 PUD_PAGE_SIZE/PMD_PAGE_SIZE
In-Reply-To: <20080129050631.A60EE1B416E@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0801311651310.9204@apollo.tec.linutronix.de>
References: <20080129606.610336873@suse.de> <20080129050631.A60EE1B416E@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Andi Kleen wrote:
> Split the existing LARGE_PAGE_SIZE/MASK macro into two new macros
> PUD_PAGE_SIZE/MASK and PMD_PAGE_SIZE/MASK. 

This is not splitting anything. It adds PUD_PAGE_xxx and renames
LARGE_PAGE_XXX to PMD_PAGE_XXX.

Please split the patch into one, which does the rename and one which
adds the new defines.

>  
> +/* Eventually 32bit should be moved over to the new names too */
> +#define LARGE_PAGE_SIZE PMD_PAGE_SIZE
> +#define LARGE_PAGE_MASK PMD_PAGE_MASK

Grep tells, that there is no remaining user of LARGE_PAGE_XXX, so this
is useless. Even if there would be users we'd better fix them right
away.

Thanks,
	tglx
