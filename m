Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbZIURQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbZIURQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIURQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:16:46 -0400
Received: from lucidpixels.com ([75.144.35.66]:52699 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZIURQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:16:45 -0400
Date: Mon, 21 Sep 2009 13:16:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: news@phoronix.com
Subject: Intel P55KG motherboard benchmarks, why are the benchmarks slow?
Message-ID: <alpine.DEB.2.00.0909211309380.30027@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This has been discussed in a few forums:
http://www.phoronix.com/scan.php?page=article&item=intel_p55&num=3

Specifically:
[ 0.781758] ACPI Warning: \_PR_.CPU0._PSS: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
[ 0.781763] ACPI: Invalid _PSS data
[ 0.781855] [Firmware Bug]: BIOS needs update for CPU frequency support
[ 0.781897] ACPI Warning: \_PR_.CPU2._PSS: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
[ 0.781900] ACPI: Invalid _PSS data
[ 0.782000] [Firmware Bug]: BIOS needs update for CPU frequency support
[ 0.782040] ACPI Warning: \_PR_.CPU4._PSS: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
[ 0.782044] ACPI: Invalid _PSS data
[ 0.782140] [Firmware Bug]: BIOS needs update for CPU frequency support
[ 0.782180] ACPI Warning: \_PR_.CPU6._PSS: Return type mismatch - found Integer, expected Package 20090521 nspredef-940
[ 0.782184] ACPI: Invalid _PSS data

Could this be the culprit as to why the i870 was so slow during all of the
benchmarks here:
http://www.phoronix.com/scan.php?page=article&item=intel_lynnfield&num=1

While the anandtech article:
http://anandtech.com/cpuchipsets/showdoc.aspx?i=3641

- Shows the new 870 outperforming the 920 in nearly every test?
- Why is the linux performance so poor?  BIOS issue?
- Does anyone have any new benchmarks with an updated BIOS?

- Or, are the benchmarks on anandtech taking advantage of new features in 
the CPU not available with programs compiled with GCC or is this just due 
to the BIOS bug?  I suspect the latter, but was curious..

Justin.

