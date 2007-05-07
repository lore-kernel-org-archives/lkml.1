Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXEGLWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXEGLWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXEGLWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:22:54 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1298 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933041AbXEGLWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:22:53 -0400
Date: Mon, 7 May 2007 13:22:40 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
In-Reply-To: <m3tzupc6wz.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0705071318150.1479@scrub.home>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3y7k1biov.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0705070343330.2733@scrub.home> <m3tzupc6wz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2007, Krzysztof Halasa wrote:

> Roman Zippel <zippel@linux-m68k.org> writes:
> 
> > What's the advantage? The HDLC option is directly before this?
> 
> You don't have to know it's required, you can just select a driver
> for your hardware, without enabling HDLC first.

Is this a real problem?
Using select you should also consider removing HDLC as visible option and 
use only select. Mixing depends and selects is generally a bad idea.

bye, Roman
