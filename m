Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbXEJVlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbXEJVlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbXEJVlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:41:40 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43727 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbXEJVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:41:39 -0400
Date: Thu, 10 May 2007 23:34:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
In-Reply-To: <6143.1178828419@lwn.net>
Message-ID: <Pine.LNX.4.61.0705102326470.6426@yvahk01.tjqt.qr>
References: <6143.1178828419@lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 14:20, Jonathan Corbet wrote:
>
>Who knew a documentation patch would get so many reviews?  I like it...

And the next thing is register-considered-harmful.txt. Running

	grep -Pr '\bregister\s+(unsigned|char|short|int|long|float|
	double|struct|union|uint|u\d+|s\d+)\b' linux-2.6.21/ | wc -l

turns up no less than 1106+2 hits.


	Jan
-- 
