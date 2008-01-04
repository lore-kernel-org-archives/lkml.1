Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYADLSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYADLSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYADLSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:18:10 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:5630 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYADLSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uYdFadd0DroPDVfWRJtd1u9fExSjgOox0X3Vmm69UsZ9KIvZYAG5Yr+32qw64I5Zf3afMfckIV790KpOj5Cbt+t50zHqtF9XKLniw9/jbm8E8wWvrP5wxxaOqfUZOeD89gxGF2AmpX5vLSHu3f7lQBtFq4TdONbs5U1whQ5lmik=
Message-ID: <4d8e3fd30801040318q2e3be951rbf517f7d6022ae04@mail.gmail.com>
Date: Fri, 4 Jan 2008 12:18:07 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] This patch to profile.c fixes a few errors reported by checkpatch.pl
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080104083442.GD22803@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104003253.7a7309d8@paolo-desktop>
	 <20080104083442.GD22803@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 9:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> > Before:
> > total: 25 errors, 13 warnings, 602 lines checked
> >
> > After:
> > total: 3 errors, 13 warnings, 602 lines checked
>
> thanks, applied. Would you be interested in fixing the other errors and
> warnings too? (Feel free to ask how to resolve certain types of
> warnings. I just took a quick look and all the current checkpatch.pl
> output on profile.c shows genuine style issues.)

Yes I am.

First of all I would like to be sure that my usage of checkpatch.pl is corretc,
what I do is the following:

paolo@paolo-desktop:~/linux-2.6/kernel$ ../scripts/checkpatch.pl
--file profile.c

and then I start fixing the errors (so far I didn't start looking at
the warnings).

What I still don't understand are the following options:
 --no-tree    => run without a kernel tree
 --root       => path to the kernel tree root

Should I specify the path to the kernel tree root? If so, why?

That said, the errors reported by checkpatch.pl are now:
paolo@paolo-desktop:~/linux-2.6/kernel$ ../scripts/checkpatch.pl
--terse --file profile.c |grep ERROR
profile.c:128: ERROR: "foo * bar" should be "foo *bar"
I just forgot to fix it, very trivial. Will do in a minute.

profile.c:460: ERROR: do not use assignment in if condition (+  if
(!(entry = create_proc_entry("XXXXXXXXXXXXX", 0600, root_irq_dir))))
profile.c:594: ERROR: do not use assignment in if condition (+  if
(!(entry = create_proc_entry("XXXXXXX", S_IWUSR | S_IRUGO, NULL))))
Here I need an hint ( or an example) about how to fix these two errors :-)

After that, I'll focus on the warnings.

Thanks Ingo!

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
