Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZAKD3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZAKD3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZAKD3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:29:42 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50390 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZAKD3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:29:41 -0500
Date: Sun, 11 Jan 2009 03:29:38 +0000
From: Andrew Price <andy@andrewprice.me.uk>
To: linux-kernel@vger.kernel.org
Subject: make distclean currently broken (indirectly)
Message-ID: <20090111032938.GA27629@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a 'heads up' to mention that there's a zero-sized file in Linus' tree
which gets removed by make distclean. It's arch/arm/mach-integrator/clock.h

I sent a patch ( http://lkml.org/lkml/2009/1/7/269 ) a few days ago to git-rm
the empty file but admittedly the subject wasn't exactly attention-grabbing.

Regards,
--
Andrew Price
