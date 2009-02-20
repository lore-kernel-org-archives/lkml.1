Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZBTIg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZBTIg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbZBTIgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:36:15 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:38619 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbZBTIgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:36:14 -0500
Date: Fri, 20 Feb 2009 09:36:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Sasa Sasa <sasak.1983@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm@vger.kernel.org,
       marc.pignat@hevs.ch, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: I2C query regarding baud rate
Message-ID: <20090220093600.367e85f6@hyperion.delvare>
In-Reply-To: <aecf5e530902192209o37eea15djd24adfeaf84ca0b0@mail.gmail.com>
References: <aecf5e530902192209o37eea15djd24adfeaf84ca0b0@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please direct I2C-related questions to the i2c-linux mailing list (now
Cc'd.)

On Fri, 20 Feb 2009 11:39:57 +0530, Sasa Sasa wrote:
> I have a query regarding the baud rate of I2C controller. Our I2C
> controller supports 3 different baud rates. So is there any possible
> or standard way for I2C clients to set this baud rate on I2C adaptor
> dynamically?

No, we do not have any way to do this at the moment. But I2C bus speed
is a tricky affair to start with. Not taking HS-I2C into account for a
moment, the I2C bus speed is a bus-wide setting, not a per-chip
setting, so letting each I2C chip driver change the bus speed doesn't
make sense. The I2C bus speed must be set once and for all according to
which devices are present on the bus (which is something only the
system designer knows.)

-- 
Jean Delvare
