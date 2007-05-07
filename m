Return-Path: <linux-kernel-owner+w=401wt.eu-S966882AbXEGU6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966882AbXEGU6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966635AbXEGU6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:58:10 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3659 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966607AbXEGU6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:58:09 -0400
Date: Mon, 7 May 2007 22:57:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jeff Garzik <jeff@garzik.org>
cc: Satyam Sharma <satyam.sharma@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
In-Reply-To: <463F8CB4.3040603@garzik.org>
Message-ID: <Pine.LNX.4.64.0705072254020.2733@scrub.home>
References: <m3abwhcy74.fsf@maximus.localdomain>  <Pine.LNX.4.64.0705070343330.2733@scrub.home>
  <m3tzupc6wz.fsf@maximus.localdomain>  <Pine.LNX.4.64.0705071318150.1479@scrub.home>
  <m3r6psc0ee.fsf@maximus.localdomain>  <Pine.LNX.4.64.0705071509290.1479@scrub.home>
  <463F27CE.2040008@garzik.org>  <Pine.LNX.4.64.0705071538060.1479@scrub.home>
  <m3lkg0a88y.fsf@maximus.localdomain>  <Pine.LNX.4.64.0705071901020.1479@scrub.home>
 <a781481a0705071115v5bce9382q166b9c0e0c52c6ef@mail.gmail.com>
 <463F8CB4.3040603@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2007, Jeff Garzik wrote:

> Tough, the kernel community has voted against you.
> 
> It makes far more sense to include a driver during kernel configuration, and
> have that driver pull in its libraries via 'select'.  The lame alternative
> requires developers to know which libraries they need BEFORE picking their
> drivers, which is backwards and requires legwork on the part of the kernel
> developer.

Jeff, there was never anything to "vote" about! There is no 
autoconfiguration, kernel configuration isn't ready for Aunt Tilly and 
select is no substitute for it...

bye, Roman
