Return-Path: <linux-kernel-owner+w=401wt.eu-S933529AbYEUGBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529AbYEUGBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbYEUGAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:00:50 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32721 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446AbYEUGAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:00:49 -0400
Date: Wed, 21 May 2008 08:00:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c : use class_for_each_device
Message-ID: <20080521080039.49e6ea9f@hyperion.delvare>
In-Reply-To: <a8e1da0805201830q88665afnf00e5f96f832f90@mail.gmail.com>
References: <20080509072029.GA2740@darkstar.te-china.tietoenator.com>
	<20080520193113.19ef0dc5@hyperion.delvare>
	<a8e1da0805201829n439f251uef438bca0b1d006@mail.gmail.com>
	<a8e1da0805201830q88665afnf00e5f96f832f90@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 09:30:59 +0800, Dave Young wrote:
> On Wed, May 21, 2008 at 9:29 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > On Wed, May 21, 2008 at 1:31 AM, Jean Delvare <khali@linux-fr.org> wrote:
> >> ... but calling another one? Can't be correct. Which raises a question:
> >> you didn't test your patch, did you? I'm also surprised how you managed
> >> to mess this up, given that all you had to do was to move already
> >> existing code around.
> >
> > Thanks for review, It's only boot-tested with i2c part as built-in by
> > me because I have the i2c device to test.
> 
> should be "have no the i2c device to test" ;)

Too late for this time, but for next time, you can emulate an i2c
device using the i2c-stub driver, that's very convenient when you want
to test a change that affects i2c and don't have any physical device to
test it.

-- 
Jean Delvare
