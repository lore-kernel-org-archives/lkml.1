Return-Path: <linux-kernel-owner+w=401wt.eu-S935421AbYEUOJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935421AbYEUOJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbYEUOJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:09:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57912 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756525AbYEUOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:09:30 -0400
X-Sasl-enc: V/Rfwj96K2SEvYbKeR6hlNQRBozxQou3jl1gZ28vG5wP 1211378969
Date: Wed, 21 May 2008 11:09:27 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
Message-ID: <20080521140927.GB3677@khazad-dum.debian.net>
References: <4832A211.4040206@gmail.com> <20080520132817.03fb74ea@hyperion.delvare> <20080521093520.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521093520.ZZRA012@mailhub.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Dmitry Torokhov wrote:
> I don't think that input subsystem woudl be the best choice. While we
> do support the event-driven mechanism for delivering information to
> userspace input is mostly oriented for human interface devices, not
> general data acquisition. If anything input_dev is too fat. Another
> thing is that input layer anonymizes input devices, makes them
> capability-oriented. I.e. we dont really care what model of joystick
> we have, we want something that reports ABS_X, ABS_Y, BTN_FIRE and
> userpsace can use it whether it a simple analog joystick or something
> fancy and USB connected. For your purposes you probably do want to know
> what the device is and what exactly being sampled/measured.
> 
> I'd go with a lean and mean new subsytem.

Agreed.  I have put some thought on it in the past, and while the input
subsystem is the only thing even remotely usable for this *right now*, a
new subsystem for data acquisition would be the best way forward.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
