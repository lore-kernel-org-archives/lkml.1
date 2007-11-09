Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbXKIOVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbXKIOVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 09:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759848AbXKIOVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 09:21:36 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:55366 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbXKIOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 09:21:35 -0500
Date: Fri, 9 Nov 2007 14:21:26 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alberto Gonzalez <info@gnebu.es>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Laptop's HDD
In-Reply-To: <200711040002.25784.info@gnebu.es>
Message-ID: <Pine.LNX.4.64N.0711091416570.914@blysk.ds.pg.gda.pl>
References: <200711040002.25784.info@gnebu.es>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007, Alberto Gonzalez wrote:

> The problem comes from a very high rate of load/unload cycles of the heads 
> that reaches the 300.000-600.000 limit in 2-3 years (with smartmontools it 
> can checked it with "smartctl -A /dev/sda")  . There are reports of HDD dying 
> even earlier for this problem [2]

 I use:

# hdparm -B 255 /dev/hda

to get rid of the problem with an ATA disk where I do not care that much 
about power consumption.  I do not know what the equivalent for a SATA 
disk would be, but chances are it will be easier to track it down with the 
reference above.

  Maciej
