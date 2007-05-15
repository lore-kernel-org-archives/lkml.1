Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbXEOSOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbXEOSOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXEOSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:14:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746AbXEOSOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:14:18 -0400
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 14:14:18 EDT
Date: Tue, 15 May 2007 11:02:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: art@usfltd.com
cc: linux-kernel@vger.kernel.org
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
In-Reply-To: <20070515124256.ijmnpcako4g8w8g0@67.106.77.50>
Message-ID: <alpine.LFD.0.98.0705151101030.3890@woody.linux-foundation.org>
References: <20070515124256.ijmnpcako4g8w8g0@67.106.77.50>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 May 2007, art@usfltd.com wrote:
> 
> it works OK with kernel-2.6.20
> 
> can update udev to version 111 help solve this problem ???

Before that, can you pinpoint more closely when the problem appeared? Is 
it there in 2.6.21 already? Bisect a few times to narrow it down even 
further?

	git bisect start
	git bisect good v2.6.20
	git bisect bad

.. go, gadget, go!

		Linus
