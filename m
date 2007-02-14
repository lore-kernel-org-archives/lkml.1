Return-Path: <linux-kernel-owner+w=401wt.eu-S1750822AbXBNRZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750822AbXBNRZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbXBNRZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:25:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38610 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbXBNRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:25:17 -0500
Subject: Re: SATA-performance part 2
From: Arjan van de Ven <arjan@infradead.org>
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702141011.20832.fink@mpe.mpg.de>
References: <200702141011.20832.fink@mpe.mpg.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 14 Feb 2007 18:25:11 +0100
Message-Id: <1171473911.12771.427.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> after deinstallation of oprofile and only soft reboots (no hardware power off) 
> these values STAYED (linux 48 MB/s) !! even for a brand new installation of 
> OpenSuSE 10.2 to another partition!
> After a hardware power off everything was again like before (26 MB/s).
> 
> So now the interesting questions to me are:
> 
> 1. What is oprofile doing with my system ?? Especially what is been changed 
> that remains a reboot ??


this is odd. (but encouraging).. the one thing I can imagine oprofile
doing is disabling the nmi_watchdog... you can simulate the same effect
by passing "nmi_watchdog=0" on the kernel commandline
(and there's something in /proc/sys as well to disable it at runtime)


