Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbYDSPG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbYDSPG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762100AbYDSPGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:06:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:10163 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761967AbYDSPGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=HI+y4/Bm9YzFq1+lDoguWtlVr9b+5IM/CHRyJhWPNOCjVOsR3VgillX/m9WgM5CyYButy/d5V4k/jpLXjZboeaVmaPDezvyvCGULsq9+KKTvAZPaBzPXvq3R3EaWLQ8L3jQ6UmdckDf5k79D6GWLXdKwMYbcYFOOePREeZoocP8=
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:10 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 00/10] x86: cleanup patches
Message-ID: <480a0a62.1abd600a.2e2c.0d80@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the collection of clean up patch for x86.
These patches can be applied to the latest x86.git.

1-3: cleanup mpparse.c
4: cleanup alloc_bootmem() usage
5: cleanup clocksource_hz2mult() usage
6: cleanup div_sc() usage
7: use cpumask functions
8-10: propagate the use of get_bios_ebda()
