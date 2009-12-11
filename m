Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbZLKLzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbZLKLzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761044AbZLKLzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:55:41 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36379 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760889AbZLKLzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:55:40 -0500
Date: Fri, 11 Dec 2009 11:55:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20091211115538.GB25806@sirena.org.uk>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <1260531086-23857-2-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260531086-23857-2-git-send-email-felipe.balbi@nokia.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 01:31:22PM +0200, Felipe Balbi wrote:
> The notifier will be used to communicate usb events
> to other drivers like the charger chip.

> This can be used as source of information to kick
> usb charger detection as described by the USB
> Battery Charging Specification 1.1 and/or to
> pass bMaxPower field of selected usb_configuration
> to charger chip in order to use that information
> as input current on the charging profile
> setup.

This one looks reasonable to me, though I've not thought it through
properly yet.  Could you please add me to the CC list for future
revisions of this - I've got some charger drivers that could use this?
