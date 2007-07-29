Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbXG2Eht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbXG2Eht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 00:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXG2Ehj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 00:37:39 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:23472 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbXG2Ehj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 00:37:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXAMC2q0ZKhRO4Rmdsb2JhbACBToVqiCQBAQEWDQYMAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: [PATCH] TSDEV - Don't flood dmesg with removal warnings
Date: Sun, 29 Jul 2007 00:37:36 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
References: <Pine.LNX.4.64.0707271038100.5691@parag-desktop>
In-Reply-To: <Pine.LNX.4.64.0707271038100.5691@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707290037.37606.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Parag,

On Friday 27 July 2007 10:43, Parag Warudkar wrote:
> Ignore my previous whitespace damaged patch. This one should be good.
> 
> tsdev.c warns about scheduled removal each time tsdev_open is called -
> So even for a default boot I get to see the warning 3 times -
> 
> [  340.537078] tsdev (compaq touchscreen emulation) is scheduled for
> removal.
> [  340.537081] See Documentation/feature-removal-schedule.txt for details.
> [  340.550314] tsdev (compaq touchscreen emulation) is scheduled for
> removal.
> [  340.550318] See Documentation/feature-removal-schedule.txt for details.
> [  340.565065] tsdev (compaq touchscreen emulation) is scheduled for
> removal.
> [  340.565068] See Documentation/feature-removal-schedule.txt for details.
> 
> Move the warning to tsdev_init() from tsdev_open so we don't end up
> printing a large string in dmesg everytime tsdev_open is called.
>

The printk was moved per Andrew's request to make it more annoying.
Obviously it is working ;) Do you know what is opening /dev/input/tsX
nodes?

-- 
Dmitry
