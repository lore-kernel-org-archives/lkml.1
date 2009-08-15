Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZHOVgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZHOVgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 17:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZHOVgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 17:36:10 -0400
Received: from aun.it.uu.se ([130.238.12.36]:56860 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZHOVgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 17:36:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19079.10822.924132.738479@pilspetsen.it.uu.se>
Date: Sat, 15 Aug 2009 23:36:06 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.31-rc6: pty regressed again, breaking expect and gcc's testsuite
In-Reply-To: <19077.63001.363319.810332@pilspetsen.it.uu.se>
References: <19077.63001.363319.810332@pilspetsen.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > I previously reported that 2.6.31-rcN (1 <= N < 5) broke expect
 > and gcc's testsuite, resulting in bogus gcc testsuite failures.
 > That got fixed in -rc5.

Correction. That got fixed in -rc5 on my main workstation,
which has a fairly old userspace. On another machine with
a newer userspace, expect still breaks with -rc5.

 > However, on -rc6 I'm now seeing a similar problem: one specific
 > test (gcc.dg/c99-typespec-1.c) works on 2.6.30 and 2.6.31-rc5,
 > but signals a failure on 2.6.31-rc6.
 > 
 > (Not bisected, I've just spent a lot of time reverting gcc patches
 > and regression testing the result to make sure they weren't at fault.)
