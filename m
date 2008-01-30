Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYA3AtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYA3AtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYA3AtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:49:08 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:43559 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYA3AtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:49:06 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Jon Masters <jonathan@jonmasters.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <Pine.LNX.4.64.0801300129270.14907@fbirervta.pbzchgretzou.qr>
References: <1201641765.18773.35.camel@dv>
	 <1201652420.2271.91.camel@perihelion>
	 <Pine.LNX.4.64.0801300129270.14907@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 29 Jan 2008 19:48:14 -0500
Message-Id: <1201654094.2271.105.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 01:35 +0100, Jan Engelhardt wrote:
> On Jan 29 2008 19:20, Jon Masters wrote:

> >Another fix would be for ndiswrapper to explicitly set the taint when it
> >loads a tainted driver? Or do we just want to go back to globally
> >"tainting" the kernel without assigning the blame to any module?
> 
> I think the global taint flag is always needed because you never know
> what the proprietary module actually did to our memory. Unloading
> the driver and ndiswrapper should retain some sort of taintedness
> should it oops much later.

It will. The module taint variant also sets the global taint. But it
helps to know why you set that if you oops now and get a list of
modules. Yeah, we know about ndiswrapper, I just mean in general.

Man, that'll teach me to send one-liners without checking the entire
history of LWN stories beforehand. I'm going to the gym to escape :)

Jon.


