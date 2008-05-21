Return-Path: <linux-kernel-owner+w=401wt.eu-S934324AbYEUNUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324AbYEUNUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760229AbYEUNU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:20:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2554 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbYEUNUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:20:25 -0400
Date: Wed, 21 May 2008 15:20:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
Message-ID: <20080521152009.0a227c3e@hyperion.delvare>
In-Reply-To: <4833F3B6.6020806@gmail.com>
References: <4832A211.4040206@gmail.com>
	<20080520132817.03fb74ea@hyperion.delvare>
	<20080520214005.GH3220@local>
	<4833F3B6.6020806@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 11:04:38 +0100, Jonathan Cameron wrote:
> Definitely agreed that it makes sense to put DACs and ADCs in the same 
> general place and obviously there are plenty of devices out there that do
> both.

Note that hardware monitoring chips can include ADCs and DACs: the
former to monitor system voltages, and the later to control fans (most
chips use PWM for that but a few use DACs.) ADCs and DACs are, much
like GPIOs, usable for a variety of different purposes. I doubt that
there would be any benefit in abstracting DACs and ADCs the way we did
for GPIOs, but the important point here is that we really want to group
the drivers according to their functionality and not technical
implementation details.

-- 
Jean Delvare
