Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZADKbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZADKbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZADKbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:31:23 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:57740 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZADKbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:31:22 -0500
Subject: Re: [RFC] Regulator: Possibility of passing notifications of non
 alarm events.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, broonie@opensource.wolfsonmicro.com
In-Reply-To: <495FD46E.8040208@cam.ac.uk>
References: <495FD46E.8040208@cam.ac.uk>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 10:31:18 +0000
Message-Id: <1231065078.11643.116.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-03 at 21:11 +0000, Jonathan Cameron wrote:
> Dear All,
> 
> I am in the process of writing an hwmon driver for the Sensiron SHT15 humidity
> sensor.
> 
> In common (I assume) with lots of other devices, the formula for converting
> the outputs of this chip to real units involves the supply voltage.
> Unfortunately the chip doesn't itself have any means of measuring this.
> Obviously this can be supplied via a board config if it is constant.
> 
> As I have it connected to a DA9030 pmic I can register it as a consumer
> and hence query what the pmic thinks it is supplying.
> 
> Unfortunately this regulator is shared with a number of other chips and so
> there is no guarantee that this voltage won't be changed (within the bounds
> supported by the SHT15).  I'd like to avoid querying the regulator voltage
> every time I do a conversion.
> 
> As the regulator framework already allows you to register to receive events
> such as under voltage detections, it seems to me that it would also make sense
> to allow registrations of handlers for events that occur during normal
> operation such as voltage changes.
> 
> What do people think to adding this functionality?

Sounds fine. I assume you have a patch in development ;)

Thanks

Liam


