Return-Path: <linux-kernel-owner+w=401wt.eu-S1763456AbXKMVip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763456AbXKMVip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760403AbXKMVig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:38:36 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:46519 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759944AbXKMVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:38:34 -0500
Date: Tue, 13 Nov 2007 16:34:58 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Julia Lawall <julia@diku.dk>
cc: khali@linux-fr.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/i2c: Drop redundant includes of
 moduleparam.h
In-Reply-To: <Pine.LNX.4.64.0711132231080.18337@ask.diku.dk>
Message-ID: <alpine.LFD.0.9999.0711131632490.26111@localhost.localdomain>
References: <Pine.LNX.4.64.0711132231080.18337@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Julia Lawall wrote:

> Send to:
> khali@linux-fr.org,
> i2c@lm-sensors.org,
> linux-kernel@vger.kernel.org,
> kernel-janitors@vger.kernel.org
>
> Subject: [PATCH 1/4] drivers/i2c: Drop redundant includes of moduleparam.h
>
>
> ------------------------------------------------------
>
> From: Julia Lawall <julia@diku.dk>
>
> Drop #include <linux/moduleparam.h> in files that also include #include
> <linux/module.h>.  module.h includes moduleparam.h already.

i'm not convinced that's a good idea.  while module.h does currently
(and unfortunately) include moduleparam.h, there may come a day when
those header files are refactored to actually make sense, at which
point all those missing moduleparam.h inclusions will cause all sorts
of bad things to happen.

rday

p.s.  i tried that cleanup once.  it got ugly in a hurry.

--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
