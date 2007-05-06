Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbXEFB1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbXEFB1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 21:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXEFB1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 21:27:17 -0400
Received: from web52606.mail.re2.yahoo.com ([206.190.48.209]:36932 "HELO
	web52606.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753805AbXEFB1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 21:27:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tr2QxEWR4vV8ybDMOoMWOe2Ngo7bowpZe9umCON0mKcLUl19RhPvO7CDk3QpMFegg/ijiTFJUvMSy4JOAfrsi6ggVW41mzqfrbk60Ok7Cy4z6N5DSCjN0lhdzHUMRPhjcecXFhnoMfiL1lRpNfQN7rE3utonUkIHM2rKNX2QckY=;
X-YMail-OSG: kKGneXcVM1m6g4uu4QWinhXEjgIL196RRCYT3ccdk3vhWXgyezEZ3z02lEvdH8zVW0hzQMf7ooR5wIWzRfFCW9mh3C2hMPG9VrWVfPoL6VLIgb9iaffQw4hb_G.IgUQmKbrRJgq04bWbeSY-
Date: Sun, 6 May 2007 11:27:11 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.21-git oops
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0705051637k6e39bcds76456ea5ff5f11c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <124044.57210.qm@web52606.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi Srihari,

Hello Michal,

[...]

> > It turns out the system is no go with 4 GB of RAM (4 * 1 GB modules):
> system
> > instability & SATA controller doesn't detect the drives (as I reported to
> > linux-ide:
> > http://www.mail-archive.com/linux-ide@vger.kernel.org/msg06174.html).
> >
> > With only 2 GB of RAM (with either pairs), system is very stable
> (surviving
> > many parallel kernel compiles for over 3 times longer than that of 4 GB),
> and
> > it detects & works fine with the SATA drives also.
> >
> > Any advice on getting all of 4 GB to work reliably with SATA also?

[...]

> This looks like a bad RAM problem too me. Check the RAM memory
> http://www.memtest.org/

I disagree it to be a bad RAM problem (please read on). But agree undeniably
to run the memtest a little later on (FWIW, Linux & kernel compile tests are
indeed my test case to prove the stability of the machine).

(I can assure no component is overclocked; I prefer stability over performance
with instability :-). Power & ventilation seem quite adequate, but nonetheless
I haven't eliminated yet - for stability, not for SATA detection.)

Assuming it's indeed a bad RAM (which I don't sincerely/logically believe),
may I ask then how would you explain:
1. SATA drives aren't even detected with 4 GB of RAM
2. Or the system working reliably with _both_ pairs of memory modules
individually, ie when limited to 2 GB only, when kernel compile torture test
succeeds for many hours with no problems (repeated the test case for a few
times also to prove the memory modules are themselves in very good condition),
while crashing in a few minutes reliably/repeatably under 4 GB

Logically speaking, if I were to hypothesize what the problem might be:
1. mother board is no go with 4 GB of RAM (for both system stability & SATA
drives detection) - Escalated it to Asus to confirm.
2. (my dearest) Linux kernel doesn't configure/program things in this board to
work reliably.
3. Sadly I don't know yet if there is a boot parameter for Linux or a
configuration setting in BIOS to make things work both reliably & completely.

(I vaguely remember in a thread a few weeks/months ago in LKML on AMD64/Nvidia
chipset combo, using SW IOMMU lead to improved stability on machines with
large amount of RAM?? Or was that limiting the RAM to under 4 GB that helped??
I could be completely wrong here.)

> (Removed from the list of known regressions
> http://kernelnewbies.org/known_regressions)

(Initially I believed it to be a regression wrongly, but it was not. Since
then I've eliminated a few variables in my tests. Sorry for my
misunderstanding.)

Thank you for your help so far.

Hari



Send instant messages to your online friends http://au.messenger.yahoo.com 
