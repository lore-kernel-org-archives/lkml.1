Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbYKVPyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbYKVPyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 10:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbYKVPyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 10:54:33 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:45992 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461AbYKVPyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 10:54:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gYmF8GSSlOXTg9MgfuOjOz0M60GiCTdDofEjPR81id9EYs69PHCmsJ7ck4XhuDIbVr
         HCWKAC6sq5yE1LY+tKBZKvpH6PIdPaIK2njjeL7MkzWPzBSO2KzjV91vfbclk6paE/Yg
         XiPG2eOb37zpyNlcMRzQDBnMRztBFGSm0Wie0=
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, stefan@datenfreihafen.org,
       sameo@openedhand.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <f17812d70811220601p1d7af668mf3265224179753ab@mail.gmail.com>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org>
	 <20081121160521.016544616@dodger.lab.datenfreihafen.org>
	 <200811212125.49068.david-b@pacbell.net>
	 <f17812d70811220601p1d7af668mf3265224179753ab@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 22 Nov 2008 13:54:22 -0200
Message-Id: <1227369262.19591.41.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sáb, 2008-11-22 às 22:01 +0800, Eric Miao escreveu:
> On Sat, Nov 22, 2008 at 1:25 PM, David Brownell <david-b@pacbell.net> wrote:
> > On Friday 21 November 2008, stefan@datenfreihafen.org wrote:
> >> Since the last submission we are also using the spi subsystem and
> >> pxa2xx-spi instead of ssp.c directly as before.
> >
> > I took a quick glance at this and it seemed like it should be
> > able to build without depending on PXA ... should certainly
> > not include <mach/ssp.h> or <mach/regs-ssp.h>, and it doesn't
> > look like it needs PXA-specific stuff like <mach/mfp-pxa27x.h>
> > either.
> >
> > It's also worth removing the reverse dependencies ("select X")
> > from Kconfig; they don't work very well for the things which
> > those dependencies rely on.
> >
> I'm wondering if it call fall into the regulator framework, along with
> a hwmon driver with its attributes being exported by sysfs.

The ADC is also used by the touchscreen driver, and later will be used
for accessory detection (usb otg, charger, EMU (audio and uart on usb
port)).

Currently the only user for the voltage regulators is the MMC, i plan to
use the regulator subsystem when more users arise.

-- 
Daniel Ribeiro

