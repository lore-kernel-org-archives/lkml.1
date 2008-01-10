Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbYAJWfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbYAJWfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYAJWfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:35:43 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:49721 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754688AbYAJWfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qqnsAH5h9lVxr1E1w0fdnKkC9WylADP6HL4E0mnf2VdFBSMBFkVG5dsujQ0V/AvseUY96AmgHdjbtk2QPCKr9mhsKnpQLqKkTtv/umeXM6S574vKeJhoRzgNpkEg81sBbrFZWCC7e+iTner0vAIC7afITGeid85ka7XvUw/TbAc=
Message-ID: <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
Date: Thu, 10 Jan 2008 23:35:39 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [x86] list of style offenders
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1199995391.29897.26.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199995391.29897.26.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 9:03 PM, Daniel Walker <dwalker@mvista.com> wrote:
>
>
> I was playing with checkpatch.pl ;) .. I made a list of style offenders
> inside the arch/x86/ sub-directory. I thought it might be helpful to
> prioritize any style clean ups that people might want to do for x86 ..
> OTOH some of these might show imperfections in checkpatch.pl .. Either
> way I thought it was interesting to review ..
>
> These are sorted by errors, then warnings.. I only included the first
> hundred files which includes about the top %30 of the list .. The
> kprobes_64.c error rate is a little miss-leading because several errors
> are found on a single line ..

I just pulled
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86 mm

> ./arch/x86/math-emu/fpu_trig.c
>                 total: 649 errors, 11 warnings, 1845 lines checked

On that tree checkpatch reports:
total: 5 errors, 54 warnings, 1643 lines checked

> ./arch/x86/kernel/kprobes_64.c
>                 total: 528 errors, 9 warnings, 749 lines checked

total: 0 errors, 0 warnings, 1 lines checked

> ./arch/x86/math-emu/reg_ld_str.c
>                 total: 392 errors, 17 warnings, 1375 lines checked

total: 8 errors, 39 warnings, 1224 lines checked

> ./arch/x86/kernel/kprobes_32.c
>                 total: 271 errors, 8 warnings, 756 lines checked

total: 1 errors, 0 warnings, 0 lines checked

> ./arch/x86/math-emu/errors.c
>                 total: 214 errors, 28 warnings, 739 lines checked

total: 26 errors, 36 warnings, 689 lines checked

So it looks like a lot of errors are fixed in the x86 git tree.

Regards,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
