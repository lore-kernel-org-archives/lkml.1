Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983Ab0A3Jf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab0A3Jf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333Ab0A3Jf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:35:56 -0500
Received: from poutre.nerim.net ([62.4.16.124]:51990 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab0A3Jfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:35:55 -0500
Date: Sat, 30 Jan 2010 10:35:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christian Kujau <lists@nerdbynature.de>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, Stelian Pop <stelian@popies.net>,
       Michael Hanselmann <linux-kernel@hansmi.ch>
Subject: Re: i2c_powermac: Kernel access of bad area
Message-ID: <20100130103552.284209fb@hyperion.delvare>
In-Reply-To: <1264800895.20211.120.camel@pasglop>
References: <alpine.DEB.2.01.0912281934170.3483@bogon.housecafe.de>
	<1262079255.2173.216.camel@pasglop>
	<20100106173745.57207520@hyperion.delvare>
	<alpine.DEB.2.01.1001061913310.3483@bogon.housecafe.de>
	<20100107171738.2c83b13e@hyperion.delvare>
	<20100129091857.3b7228db@hyperion.delvare>
	<1264800895.20211.120.camel@pasglop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 08:34:55 +1100, Benjamin Herrenschmidt wrote:
> 
> > Ben, what about applying this patch of mine, as Christian reported it
> > fixed his oops?
> 
> Sure. I never quite know with i2c which ones you will apply directly and
> which ones you want to go through my tree :-)
> 
> Hopefully they should still be referened on patchwork, I'll dig there
> and pick them up.

Well, basically I pick patches that touch drivers/i2c/*, and I don't
pick patches that touch drivers/macintosh/*. When I can't build the
drivers, I don't really feel like pushing the patches myself.

-- 
Jean Delvare
