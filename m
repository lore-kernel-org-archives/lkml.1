Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZA2POm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZA2POm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZA2POb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:14:31 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:2810 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZA2PO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:14:29 -0500
Date: Thu, 29 Jan 2009 16:14:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] CONFIG_I2C_VIAPRO=y breaks skge
Message-ID: <20090129161418.5ced2911@hyperion.delvare>
In-Reply-To: <20090129142759.GR24391@elte.hu>
References: <20090127151359.GA20369@elte.hu>
	<20090127162729.50cd2e61@hyperion.delvare>
	<20090127154410.GA24470@elte.hu>
	<20090127182631.13568383@hyperion.delvare>
	<20090129134916.GK24391@elte.hu>
	<20090129151535.2fb84505@hyperion.delvare>
	<20090129142759.GR24391@elte.hu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 15:27:59 +0100, Ingo Molnar wrote:
> 
> * Jean Delvare <khali@linux-fr.org> wrote:
> > This VIA chipset is the bridge over which the bugs run. Blaming on it 
> > for the problem you've hit would be similar to blaming the USB host 
> > controller driver for a bug that is in the USB keyboard or mouse driver.
> > 
> > The "other I2C drivers" don't run frequently at all now that you've 
> > disabled i2c-viapro. Without an I2C bus to probe on the machine, these 
> > drivers don't do anything.
> 
> ah, okay - i see - what i thought to be a surgical workaround has cut off 
> the whole leg. Will go back to find the ailing muscle instead.

Exactly.

> > So, again, if you are still willing to help me solve the problem, please 
> > boot the bad kernel and run:
> > 
> > $ ls -l /sys/bus/i2c/devices/*/driver
> > 
> > Then we'll know which drivers attached to I2C devices on your SMBus. 
> > Figuring out which one shouldn't have will likely be straightforward.
> 
> will take some time - but i'll revisit it.
> 
> Could you give me a short list of I2C driver .config options i should 
> disable one by one (instead of viapro) ?

I can't tell you before you give me the output of
  ls -l /sys/bus/i2c/devices/*/driver
for the broken system.

-- 
Jean Delvare
