Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbZAHUTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbZAHUTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZAHUSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:18:34 -0500
Received: from 201-217-static-ppp.3menatwork.com ([64.235.217.201]:40251 "EHLO
	server.hugovil.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760708AbZAHUSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:18:32 -0500
Date: Thu, 8 Jan 2009 15:18:27 -0500
From: Hugo Villeneuve <hugo@hugovil.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: FPGA programming driver architecture
Message-Id: <20090108151827.72f50cee.hugo@hugovil.com>
In-Reply-To: <200812131358.03010.florian@openwrt.org>
References: <20081212150314.6ea24996.hugo@hugovil.com>
	<200812131358.03010.florian@openwrt.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Default is to whitelist mail, not delayed by milter-greylist-3.0 (server.hugovil.com [64.235.217.201]); Thu, 08 Jan 2009 15:18:29 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 13:58:01 +0100
Florian Fainelli <florian@openwrt.org> wrote:

> (CC'ing linux-embedded)
> 
> Salut Hugo,
> 
> Le Friday 12 December 2008 21:03:14 Hugo Villeneuve, vous avez écrit :
> > Hi,
> > I have written some code to program a FPGA in Linux, for two
> > different types of boards: one uses a serial interface (SPI) and
> > the second a parallel interface. I have been able to sucessfully
> > program both boards. I'm now trying to clean my code and make it
> > more generic, as well as better in line with the Linux driver
> > model. I would also like to include it in the mainline kernel if
> > there is interest.
> ...
> What about something like that :
> 
> - fpgaload-core which contains all the code that can be shared
> between the drivers like requesting firmware, providing sysfs
> attributes, 
> - fpgaload-spi would handle the low-level SPI connection
> - fpgaload-par would handle the low-level parallel connection
> 
> fpgaload-ser and par would register with fpgaload-core and they could
> register a fpga loading callback which is low-level specific for
> instance. Platform code would instantiate the core driver. That way,
> adding support for other loading protocols like slave serial or
> master serial can be done easily.

Yes, but how I actually implement fpgaload_core, fpgaload_ser and
fpgaload_par?

Bus driver?
class driver?
platform driver?

I am not sure how I should implement things and how each low-level
specific driver should register with the fpgaload_core driver...

Hugo V.

---------------
Hugo Villeneuve
www.hugovil.com
---------------
