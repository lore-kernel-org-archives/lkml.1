Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbYJWEsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbYJWEsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYJWEs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:48:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:44166 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYJWEs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:48:27 -0400
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Brownell <david-b@pacbell.net>
Cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
In-Reply-To: <200810221404.52798.david-b@pacbell.net>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
	 <20081022104606.GA510@oksana.dev.rtsoft.ru>
	 <20081022183218.GA19025@oksana.dev.rtsoft.ru>
	 <200810221404.52798.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 15:45:45 +1100
Message-Id: <1224737145.7654.387.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 14:04 -0700, David Brownell wrote:
> > So if we register the board infos after 
> > the controller registered, then nobody will probe the board infos.
> 
> See above.  If you're doing it right, there's no problem.
> That is, scan the OF tables early.  Just like PNP tables
> get scanned early, for example.

It's still pretty yucky in that case to scan the device-tree to convert
it into some kind of fugly board info ... I'd rather have the end
drivers that actually use those GPIOs scan the device-tree directly.

But then, I'm not a believer in generic drivers for things like GPIOs,
i2c devices, etc.. :-)

Ben.


