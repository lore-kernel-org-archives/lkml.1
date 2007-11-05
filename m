Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXKEKP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXKEKP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbXKEKPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:15:14 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:57774 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXKEKPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:15:13 -0500
Date: Mon, 5 Nov 2007 11:15:04 +0100 (CET)
From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
To: linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
In-Reply-To: <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
Message-ID: <Pine.A41.4.64.0711051110530.803034@stalin.acc.umu.se>
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se>
 <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sat, 3 Nov 2007, Matt Mackall wrote:
>
>> This is typically due to a problem with the setup of your MTRRs. Try

This is the output from cat /proc/mtrr

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
