Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZDPCBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZDPCBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZDPCA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:00:58 -0400
Received: from ozlabs.org ([203.10.76.45]:35831 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZDPCA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:00:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Date: Thu, 16 Apr 2009 11:30:26 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain> <49E62BD5.6090508@zytor.com>
In-Reply-To: <49E62BD5.6090508@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904161130.28129.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 04:17:49 am H. Peter Anvin wrote:
> Linus Torvalds wrote:
> "build fix" is valid and proper use: it tells that it
> fixes a compilation error, which succinctly communicates both the
> priority of the fix and how it needs to be validated.

Side note: I really prefer to see the compile error output in this case: great
for googling.  It annoys me when people skip this.

Anyway, Impact: had lead me to think harder about my messages than the
free-form commit style did.  Perhaps it's too rigid, but it helped.

Let's get concrete.  Here's the top 3 non-merge commits in gitk:

    ALSA: hda - Fix the cmd cache keys for amp verbs
    
    Fix the key value generation for get/set amp verbs.  The upper bits of
    the parameter have to be combined with the verb value to be unique for
    each direction/index of amp access.
    
    This fixes the resume problem on some hardwares like Macbook after
    the channel mode is changed.

I have no idea what this patch does.  It seems to be a fix; what are the
symptoms of the problem, and how long has it been there? 

    ALSA: add missing definitions(letters) to HD-Audio.txt
    
    impact: Add missing definitions(letters).

This is actually a pure documentation patch.  "Fix typos" or "Documentation
fixes" would seem sufficient for subject, and no body needed.

    ALSA: sound/pci: use memdup_user()
    
    Remove open-coded memdup_user().

Again, the body seems gratuitous.

Anyone want to try to write a guide on writing good commit messages?
Rusty.
