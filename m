Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYGWRs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYGWRs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYGWRsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:48:08 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58274 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbYGWRsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:48:06 -0400
X-Sasl-enc: kz7Pw67KJjMU5U/Xzv2r+YWjGlU+TCDoK09pJOTbPGR9 1216835284
Date: Wed, 23 Jul 2008 14:48:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/4] IndustrialIO subsystem (ADCs, accelerometers etc)
Message-ID: <20080723174801.GC11009@khazad-dum.debian.net>
References: <488763AD.4050400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488763AD.4050400@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008, Jonathan Cameron wrote:
> The subsystem is now in a functional state with a small set of drivers:
> 
> Max1363 (supports numerous Maxim i2c ADC's) (tested with max1363 and max1238 chips)
>    - Uses a periodic timer to provide ring buffer mode.
>    - All reads form these devices are scan modes so direct single element access
>      is not provided.
>    - Monitor mode on max1363 is not yet supported (need to do a bit debugging of
>      the board I have so as to be able to test this).
> 
> ST LIS3L02DQ - SPI accelerometer.
>    - Uses a datardy interrupt to driver a software ring buffer.
>    - Most functionality of this device is supported.
> 
> VTI SCA3000 (tested with an e05)
>    - Hardware ring buffer.

I'd like to see something done to have the common parts of interfaces of the
same class (e.g. accelerometers) be standard.  Like hwmon does with
temp#_input, etc.

Otherwise you made it easier to write drivers, but did nothing to help
userspace to USE the drivers :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
