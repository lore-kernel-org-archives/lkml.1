Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZIUS0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZIUS0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZIUS0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:26:45 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38428 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbZIUS0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:26:45 -0400
Date: Mon, 21 Sep 2009 14:26:48 -0400
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, news@phoronix.com
Subject: Re: Intel P55KG motherboard benchmarks, why are the benchmarks
	slow?
Message-ID: <20090921182648.GK23702@csclub.uwaterloo.ca>
References: <alpine.DEB.2.00.0909211309380.30027@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0909211309380.30027@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 01:16:48PM -0400, Justin Piszcz wrote:
> Hello,
>
> This has been discussed in a few forums:
> http://www.phoronix.com/scan.php?page=article&item=intel_p55&num=3
>
> Specifically:
> [ 0.781758] ACPI Warning: \_PR_.CPU0._PSS: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
> [ 0.781763] ACPI: Invalid _PSS data
> [ 0.781855] [Firmware Bug]: BIOS needs update for CPU frequency support
> [ 0.781897] ACPI Warning: \_PR_.CPU2._PSS: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
> [ 0.781900] ACPI: Invalid _PSS data
> [ 0.782000] [Firmware Bug]: BIOS needs update for CPU frequency support
> [ 0.782040] ACPI Warning: \_PR_.CPU4._PSS: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
> [ 0.782044] ACPI: Invalid _PSS data
> [ 0.782140] [Firmware Bug]: BIOS needs update for CPU frequency support
> [ 0.782180] ACPI Warning: \_PR_.CPU6._PSS: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
> [ 0.782184] ACPI: Invalid _PSS data
>
> Could this be the culprit as to why the i870 was so slow during all of the
> benchmarks here:
> http://www.phoronix.com/scan.php?page=article&item=intel_lynnfield&num=1
>
> While the anandtech article:
> http://anandtech.com/cpuchipsets/showdoc.aspx?i=3641
>
> - Shows the new 870 outperforming the 920 in nearly every test?

On a quick read, it appears the 870 outperforms a 920 on cpu intensive
tasks, while loosing on memory intensive tasks.  Not sure how that is
a problem.

> - Why is the linux performance so poor?  BIOS issue?

Is the performance bad?  Which of those benchmarks (whatever they do)
shows anything particularly unpexpected?

The vast majority of those tests show the 870 with a lead on cpu intensive
work, and the 920 winning slightly (although sometimes by 50%) on memory
intensive work.  That's completely expected.

The phenom winning anything on the other hand is surprising to me.
Good for AMD though.  Nice to see intel isn't always winning.

> - Does anyone have any new benchmarks with an updated BIOS?
>
> - Or, are the benchmarks on anandtech taking advantage of new features in 
> the CPU not available with programs compiled with GCC or is this just due 
> to the BIOS bug?  I suspect the latter, but was curious..

Different tests.  anandtech knows what they are doing and run sensible
benchmarks.  Not so sure that is the case for phoronix.

-- 
Len Sorensen
