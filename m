Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbXGZRFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbXGZRFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763547AbXGZRFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:05:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42331 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760980AbXGZRFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:05:13 -0400
Date: Thu, 26 Jul 2007 18:11:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, cpufreq@www.linux.org.uk
Subject: Re: [PATCH]gx-suspmod.c use boot_cpu_data instead of
 current_cpu_data
Message-ID: <20070726181153.17f83e21@the-village.bc.nu>
In-Reply-To: <20070726164654.GC32159@redhat.com>
References: <20070725141905.GA4567@darkstar.te-china.tietoenator.com>
	<20070724234045.2cec5525.akpm@linux-foundation.org>
	<a8e1da0707252120l5e9e441bm53e2ba25bc9c20f0@mail.gmail.com>
	<20070725212638.79bc3945.akpm@linux-foundation.org>
	<20070726164654.GC32159@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> a non-identical CPU system with a geode + something else doesn't exist
> and is very unlikely to happen.

As the Geode isn't used SMP (and afaik isnt SMP capable) that would be a
reasonable assumption
