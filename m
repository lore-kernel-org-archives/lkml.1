Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZIDFfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZIDFfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZIDFfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:35:46 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:34141 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZIDFfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:35:45 -0400
Date: Fri, 4 Sep 2009 07:35:33 +0200
From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
Message-ID: <20090904053532.GA26812@chram.org>
References: <6661.1251822466@nice.ram.loc> <4A9DF3E9.9090309@gmail.com> <20090902111927.GA4590@chram.org> <51f3faa70909020742g19007084j19a0ed071aaeffdf@mail.gmail.com> <20090902145225.GA16359@chram.org> <51f3faa70909021724v45d2902ewdb10d5f4a188f2be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa70909021724v45d2902ewdb10d5f4a188f2be@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Robert Hancock:
: Is it always this drive that's failing? I see there's a second of the
: same model, does it show the same behavior?
: 
: > ata1.00: ATA-6: HDS722512VLAT80, V33OA60A, max UDMA/100
: > ata1.00: 241254720 sectors, multi 16: LBA48
: 
: If only that particular drive shows this problem, then I would start
: to suspect a hardware fault with that drive. The fact that it fails
: with both IDE and libata (and with ata_piix, which is a really
: commonly used and tested libata driver) rather points in that
: direction.

That was a very good diagnosis.

I switched my two Hitachi drives for Maxtors, and the problem
went away.  I was able to do a SMART long test on all my drives
without lockups and without any kernel complaints on the console.

Thanks a lot, I had no idea these Hitachi drives had a bad firmware.
Looking at the tags on the drives, they were manufactured late 2003
and early 2004.

Raphael
