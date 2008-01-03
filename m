Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYACOAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYACOAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYACN7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:59:54 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51676 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750823AbYACN7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:59:53 -0500
Date: Thu, 3 Jan 2008 14:58:58 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Ville =?UTF-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: Add GPIO w1 bus master driver
Message-ID: <20080103145858.11fc9f0f@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080103134835.GM15861@sci.fi>
References: <1198222441690-git-send-email-syrjala@sci.fi>
	<20071226232454.039372b8@siona>
	<20080103134835.GM15861@sci.fi>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008 15:48:35 +0200
Ville Syrjälä <syrjala@sci.fi> wrote:

> On Wed, Dec 26, 2007 at 11:24:54PM +0100, Haavard Skinnemoen wrote:
> > On Fri, 21 Dec 2007 09:34:01 +0200
> > Ville Syrjala <syrjala@sci.fi> wrote:
> > 
> > > +static struct platform_device foo_w1_device = {
> > > +	.name			= "w1-gpio",
> > > +	.id			= -1,
> > 
> > Assigning -1 to a u32 member isn't a very nice example. What does it
> > mean anyway?
> 
> id is 'int'. The bus_name won't include the id when -1 is used.

Ah, indeed. I was looking at 2.6.23, where it is u32.

> > ...call platform_driver_probe(&w1_gpio_driver, w1_gpio_probe) here.
> 
> I was wondering what platform_driver_probe() was for but never bothered
> to read the code. I'll change the code to use it.
> 
> I already sent an updated patch but forgot to send this reply.

I saw it. Thanks :)

Haavard
