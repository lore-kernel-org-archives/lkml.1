Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbYGWSjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbYGWSjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbYGWSg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:36:29 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:47510 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755042AbYGWSg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:36:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4t7Yq2EM5K6UV7IZNvSm/zBnJ2vQYASKvb3dpNrU1A2cwdnIGHokqKM5hxmtnTm7kNhGBZqYn7AgPgsHJgZw5xEujyE0H82o+yx8khsoJHtUoG3DpZ6CaR8OyrZhPNtRpIbpOEBoHzfszJqr9rcrH+Kdg4Xk4Q68cjEWWuQssbg=  ;
X-YMail-OSG: Y_7hGDUVM1lU3.54SzVAEVotjFZmUX2gAOY670Wl8pfqyazvX3l3eYKRBP8aUaGZRtWhlzXrOnqsKUYO9Qm_TLNPT26cNEFpLQkwXssjWA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Subject: Re: [Patch 0/4] IndustrialIO subsystem (ADCs, accelerometers etc)
Date: Wed, 23 Jul 2008 11:36:25 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>, hmh@hmh.eng.br,
       mgross@linux.intel.com, Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
References: <488763AD.4050400@gmail.com>
In-Reply-To: <488763AD.4050400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807231136.26115.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2008, Jonathan Cameron wrote:
> * Software ring buffer support to allow semi regular capture of data form the
>   device.  Typically this will be driven from either datardy events, or from
>   a periodic timer interrupt (to this end a very simple wrapper for periodic
>   RTC's is included. This will move to more generic timer interfaces as and when
>   they become available.  For now available rtc's must be registered with the
>   subsystem via the industrialio_register_ptimer function form within a board
>   init.

Could you elaborate a bit on why you'd want hardware supported
periodic timers, rather than either an hrtimer or a timer?
Maybe provide some real-world scenarios where those software
abstractions are inappropriate.

I can imagine numerous reasons, but those might not be yours...

- Dave
