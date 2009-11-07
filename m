Return-Path: <linux-kernel-owner+w=401wt.eu-S1751567AbZKGKh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbZKGKh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 05:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZKGKh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 05:37:57 -0500
Received: from khc.piap.pl ([195.187.100.11]:59432 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZKGKhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 05:37:43 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Martin Schleier" <drahemmaps@gmx.net>
Cc: linux-kernel@vger.kernel.org, Matteo Croce <technoboy85@gmail.com>
Subject: Re: i686 quirk for AMD Geode
References: <20091106154911.29400@gmx.net>
	<20091106155937.11d95279@lxorguk.ukuu.org.uk>
	<20091106165731.26800@gmx.net>
	<20091106182218.43940287@lxorguk.ukuu.org.uk>
	<20091106200620.179910@gmx.net> <m3r5sbcl07.fsf@intrepid.localdomain>
	<20091107000559.166710@gmx.net>
Date: Sat, 07 Nov 2009 11:37:46 +0100
In-Reply-To: <20091107000559.166710@gmx.net> (Martin Schleier's message of
	"Sat, 07 Nov 2009 01:05:59 +0100")
Message-ID: <m3vdhmvcw5.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin Schleier" <drahemmaps@gmx.net> writes:

>> Did the patch in question contain such problems?
> the last point:
>  - etc... =>

Yeah.

> "WARNING: externs should be avoided in .c files

Ironically, it's the only "WARNING" while the rest are "ERRORS".
OTOH I personally believe all output from checkpatch should be labeled
"WARNING"; it's not for checkpatch to decide. It's only a tool.

> #56: FILE: arch/x86/kernel/nopl_emu.c:13:
> +void do_invalid_op(struct pt_regs *regs, long error_code);" ?
> (or do you think that this is a formatting issue?!)

Actually, I think it wasn't any issue at all at this point, when it
wasn't yet established if the patch makes sense at all.

> It is the job of a Submitter
> (as described in Documentations/SubmittingPatches section 4)
> to check and test his patches with tools like checkpatch or sparse
> before posting them.

You apparently forgot what SubmittingPatches file is all about:

"This text is a collection of suggestions which can greatly increase the
chances of your change being accepted."

You know, we don't have laws for everything here. And we're not
androids specialized in producing C code. We are supposed to use some
common sense first.

> After all this patch is going into /arch/x86 and not /drivers/staging
> and this sort of "extern declaration" is prone to break one day when
> void do_invalid_op(struct pt_regs *, long); declaration is modified.

That's true, though it's the same for "staging".
-- 
Krzysztof Halasa
