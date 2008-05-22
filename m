Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbYEVDjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbYEVDjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbYEVDi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:38:28 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:36097 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757214AbYEVDi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:38:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=c0lp/VN+KKgaMNJyIBA+WnIIbc4c+vZHg1VltUewFD8SXxQRP3TvDKVa27UmZYv8qzAasbvUORXcEAmfZ/O5vpg/GmjqWwwt9iJ4HialpHWsCtnY5GBqJbRjuh748E71J1jTKJc0ri91vdAAesL4yJ+fg1aeGH3J7yQhx+zWeqk=  ;
X-YMail-OSG: T_ir7VQVM1nCtGCxF8X9cXIpyG56Gj2pnzcxqZ1QBOGqzcQATbd.J4sSD5hI1ObjAJ3K_H8zthkDmGvpABq_HQa4EGdiZCQdEKuMn1JYxM50Q7joh.5b3e56Rbbo7SJ9yrU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
Date: Wed, 21 May 2008 17:52:15 -0700
User-Agent: KMail/1.9.9
Cc: spi-devel-general@lists.sourceforge.net,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>
References: <4832A211.4040206@gmail.com> <20080520132817.03fb74ea@hyperion.delvare>
In-Reply-To: <20080520132817.03fb74ea@hyperion.delvare>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805211752.15670.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Jean Delvare wrote:
> This all sounds quite different from our hwmon drivers. Our hwmon
> drivers read all the sensor values at once and cache the readings for a
> couple seconds, so you can't get an instant reading at any time, and
> they also don't support interrupts in general.

That's something of an issue when the hardware monitor
triggers alarms though, right?  I couldn't figure out
how to get a TMP75 alert out to any userspace code that
would care, to pick one example, even after teaching
the i2c core how to handle SMBus alerts.  ;)

I suppose this just emphasizes the point made by Hans
that we kind of need (industrial) "control" components
(or "data acquisition"?) not just "monitoring" ones.

Such alarms are of course different from the "data
ready" signals of an accelerometer.

- Dave

