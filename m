Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbXL3S0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbXL3S0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXL3S0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:26:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:2717 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbXL3S0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:26:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=D4OnUnsPbXs2gw6TaZPI7eVZ6bAITK2vUMgftm45Q9H7Cv/SeoJ+bQgAzjFXXJ2lIZp4B0Cc7TepbJz6EbWXp0DntrOonQqCgKHyloMNyH4SGjtUAYnecypsi6jBVU2FFecOLCx5Xkf6/CwC4x7VDJM3Qx+srt0scp0i88tcGWU=
Date: Sun, 30 Dec 2007 21:26:31 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] is checkpatch.pl broken
Message-ID: <20071230182631.GA7409@cvg.cvg>
References: <20071225170737.GA3887@cvg.org> <477196DC.9000704@zytor.com> <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com> <20071230172250.GD22833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230172250.GD22833@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Dec 30, 2007 at 06:22:50PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > orig:
| > mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
| > new (could be):
| > mbr_base = (buf_base + sector_size - 1) & ~(sector_size - 1);
| > 
| > Is a new version that bad?
| 
| it's certainly acceptable as newly introduced code but only borderline 
| better than the original code. I'd suggest to stick to the problem areas 
| that checkpatch.pl complains about at the moment - we have really 
| obvious bad looking pieces of code that checkpatch.pl reports, and going 
| after the borderline cases will only result in coding-style lawyering 
| and flamewars, not any genuine increase in code quality ;-)
| 
| for example:
| 
|   arch/x86/kernel/bootflag.c:
| 
|   total: 19 errors, 2 warnings, 98 lines checked
| 
| or:
| 
|   arch/x86/kernel/apm_32.c:
| 
|   total: 56 errors, 31 warnings, 2402 lines checked
| 
| and once we have nothing but the borderline cases and if we get really 
| bored we can start coding style flamewars ;-)
| 
| 	Ingo
| 

Thanks Ingo, you're quite right! Next time i'll appear in list with real
(and hope usefull) patch ;)

		Cyrill

