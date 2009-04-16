Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbZDPC2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbZDPC2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZDPC1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:27:54 -0400
Received: from mail-qy0-f107.google.com ([209.85.221.107]:58574 "EHLO
	mail-qy0-f107.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZDPC1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:27:52 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Apr 2009 22:27:52 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KFp3iwpeXv4hd+nonqEOdI7MyGq6m7A8uVWR4Xfd79sTGlnz0hz9GDyzXhkIcXW51H
         aVrASbSu6xk1pCr1/x2nFV/g2B5TGxwnCc5sDi6fhjBdE0NbmGAsGG0n8CVX7i2cFAEW
         +wShmhC/Ny8ZwZfInSQLrS7PwzIUtF7XZ+fxU=
MIME-Version: 1.0
In-Reply-To: <200904161130.28129.rusty@rustcorp.com.au>
References: <200904140159.n3E1x1K1014705@hera.kernel.org>
	 <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain>
	 <49E62BD5.6090508@zytor.com>
	 <200904161130.28129.rusty@rustcorp.com.au>
Date: Wed, 15 Apr 2009 22:22:08 -0400
X-Google-Sender-Auth: 3a0934349abf3d55
Message-ID: <7d1d9c250904151922n4c6d11d2s381a21bbc85bf48e@mail.gmail.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 10:00 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 16 Apr 2009 04:17:49 am H. Peter Anvin wrote:
>> Linus Torvalds wrote:
>> "build fix" is valid and proper use: it tells that it
>> fixes a compilation error, which succinctly communicates both the
>> priority of the fix and how it needs to be validated.
>
> Side note: I really prefer to see the compile error output in this case: great
> for googling.  It annoys me when people skip this.
>
> Anyway, Impact: had lead me to think harder about my messages than the
> free-form commit style did.  Perhaps it's too rigid, but it helped.
>
> Let's get concrete.  Here's the top 3 non-merge commits in gitk:
>
>    ALSA: hda - Fix the cmd cache keys for amp verbs
>
>    Fix the key value generation for get/set amp verbs.  The upper bits of
>    the parameter have to be combined with the verb value to be unique for
>    each direction/index of amp access.
>
>    This fixes the resume problem on some hardwares like Macbook after
>    the channel mode is changed.
>
> I have no idea what this patch does.  It seems to be a fix; what are the
> symptoms of the problem, and how long has it been there?
>
>    ALSA: add missing definitions(letters) to HD-Audio.txt
>
>    impact: Add missing definitions(letters).
>
> This is actually a pure documentation patch.  "Fix typos" or "Documentation
> fixes" would seem sufficient for subject, and no body needed.
>
>    ALSA: sound/pci: use memdup_user()
>
>    Remove open-coded memdup_user().
>
> Again, the body seems gratuitous.
>
> Anyone want to try to write a guide on writing good commit messages?

I'd put together some notes on making good commit messages for
internal use, trying to guide people into describing the symptoms of a
problem and why what is being submitted is the correct technical fix
-- vs. the semi-useless cop-outs of an English translation of the C
code itself (i.e. "increment foo comparison by one" or similar).

It isn't anything near a big wordy guide in its own right (and
hopefully it doesn't need to be), but I'm willing to use it as a
start, plus bits from this discussion, and once folks agree on the
content I put together being OK, we can stick it in Documentation
SubmittingPatches or wherever seems appropriate.  Assuming people in
general think there is a need for it...

Paul.

> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
