Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYI2VRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYI2VRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYI2VQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:16:59 -0400
Received: from eazy.amigager.de ([213.239.192.238]:51308 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYI2VQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:16:59 -0400
Date: Mon, 29 Sep 2008 23:18:03 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Regression in 2.6.27-rc7: Wake On LAN with sky2 broken
Message-ID: <20080929211803.GA3185@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20080924080546.GA21108@x61> <20080925194253.GA2783@dose.home.local> <20080925200311.GA4582@dose.home.local> <200809252238.01656.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809252238.01656.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 22:38:01 +0200, Rafael J. Wysocki wrote:
> On Thursday, 25 of September 2008, Tino Keitel wrote:
> > Hi,
> > 
> > I just found a method how I can enable WOL again:
> > 
> > echo enabled >
> > /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/power/wakeup
> > 
> > This device is the NIC device, of cause.
> 
> I guess the box didn't hang during suspend with this setting?
> 
> If that's correct, please test the patch below.

With the attached patch, WOL works as intended the hang also didn't
happen.

Thanks and regards,
Tino
