Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYAEOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYAEOhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 09:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYAEOhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 09:37:31 -0500
Received: from mx1.suse.de ([195.135.220.2]:45916 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbYAEOha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:37:30 -0500
Date: Sat, 5 Jan 2008 15:37:28 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less
	frequently
Message-ID: <20080105143728.GB2998@bingen.suse.de>
References: <20080103442.621670000@suse.de> <200801041539.27370.ak@suse.de> <alpine.LFD.0.99999.0801041546230.4042@localhost.localdomain> <200801042311.57837.ak@suse.de> <20080105011949.GA5107@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105011949.GA5107@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sloppy and inconsistent code also leaves a lasting negative impression 
> on newbie developers. I've heard quite a few opinions about Linux's code 
> base being a lot less consistent (and hence harder to understand) than 

Do you think they did refer to code style (as in indentation etc.) here? 
When I was talking to such people my impression was that their complaints
usually came from other issues.

e.g. I know from talking to a few people that they consider the BSD
kernels cleaner just because they have a very consistent printk
style for driver probing so it looks cleaner at booting. Sounds silly
(although I can sympathize a little bit) but true.

Besides the kernel indentation is not that inconsistent anyways.

> Frankly, if you dont understand the necessity of clean code, and the 
> negative effect that a large number of small uncleanlinesses can have on 
> a large system then you wont be getting the big picture either.
> 
> checkpatch.pl is not perfect (and it cannot be), and we dont use it as a 
> rigid criterium (and dont want to), but it's quite conservative (its 
> false positive rate for code that i maintain is below 1% - which is 

Rate is certainly higher here.

> sloppy patches. It gives us a way to improve the kernel's code quality 
> gradually. We change about 10% of the kernel codebase in every kernel 
> release, that is about 30% of the kernel every year. With checkpatch.pl 
> we'll have a very clean kernel in just a few years.

That's the problem I have with your position. You equate quality
with coding style or checkpatch.pl output. I think it's only a small
part of it.

If we follow your description above to the logical conclusion then we could 
get the perfect kernel(tm) very quickly just by running everything 
through Lindent or recruit a few hundred people who run all files 
through checkpatch.pl and fix all warnings and then we end up with the 
perfect kernel with "improved code quality" 

Great idea! And is it ok for me to refer to that plan as "the Ingo Molnar
plan" (TIMP) in the future? I'm sure a short term for it will come handy 
in future discussions ;-)

-Andi

