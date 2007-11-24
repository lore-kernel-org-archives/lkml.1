Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbXKXJ36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbXKXJ36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 04:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXKXJ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 04:29:50 -0500
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:3270 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbXKXJ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 04:29:49 -0500
Date: Sat, 24 Nov 2007 10:29:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: benh@kernel.crashing.org
Cc: Michael Buesch <mb@bu3sch.de>, Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       linux-kernel@vger.kernel.org, Dennis Munsie <dmunsie@cecropia.com>
Subject: Re: radeonfb i2c regression post-2.6.18.
Message-ID: <20071124102945.0d6f9934@hyperion.delvare>
In-Reply-To: <1195866664.7195.28.camel@pasglop>
References: <1195427766.7022.18.camel@pasglop>
	<200711231700.53103.mb@bu3sch.de>
	<20071123232928.467378a7@hyperion.delvare>
	<1195866664.7195.28.camel@pasglop>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 12:11:04 +1100, Benjamin Herrenschmidt wrote:
> 
> On Fri, 2007-11-23 at 23:29 +0100, Jean Delvare wrote:
> > On Fri, 23 Nov 2007 17:00:52 +0100, Michael Buesch wrote:
> > > This patch fixes my crash problem.
> > 
> > Out of curiosity, what kind of crash was it? I admit that I can't see
> > how the code could crash.
> 
> Really sneaky... apparently, keeping the i2c lines asserted on his
> laptop model would drain enough current through the pullups (or the
> chip) that the temperature will raise significantly, causing a thermal
> shutdown if the machine was already warm.
> 
> A bit scary... looks to me that a pullup is a bit too weak somewhere on
> the motherboard.
> 
> That also means that this fix should reduce power consumption on the
> battery significantly on those machines as it must take quite a bit of
> power to increase the temperature that significantly (either that, or
> the heating part sits just next to the sensor).

Wow, nasty. Then my patch really needs to go to Linus at the earliest.

Thanks,
-- 
Jean Delvare
