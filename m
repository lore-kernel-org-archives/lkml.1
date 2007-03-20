Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXCTKJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXCTKJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 06:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933509AbXCTKJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 06:09:19 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3708 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932192AbXCTKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 06:09:19 -0400
Date: Tue, 20 Mar 2007 11:08:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Bob Copeland" <me@bobcopeland.com>
Cc: "Nicolas Boichat" <nicolas@boichat.ch>, linux-kernel@hansmi.ch,
       rlove@rlove.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC][PATCH] Apple SMC driver (hardware monitoring
 and control)
Message-Id: <20070320110818.1b11c406.khali@linux-fr.org>
In-Reply-To: <b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com>
References: <45F7C083.7090504@boichat.ch>
	<b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 17:43:38 -0400, Bob Copeland wrote:
> I tried out an earlier version of this patch several months ago just to play
> around with the joystick part of the accelerometer driver on my MacBook, and
> found that it was backwards in the y-direction compared to what Neverball
> seemed to want (of course, NB has no way to invert the joystick).  I think
> I just did something like this in my own copy:
> 
> +       y = -y;
>         input_report_abs(applesmc_idev, ABS_X, x - rest_x);
>         input_report_abs(applesmc_idev, ABS_Y, y - rest_y);
> 
> I don't claim you necessarily want to change it, but thought I'd pass it
> along.

This appears to be a common problem with these devices, the hdaps driver
(IBM) needs to invert the axis on some models too, and I seem to
remember something similar for the (not yet merged) HP laptops
accelerometer driver.

-- 
Jean Delvare
