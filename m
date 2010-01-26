Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508Ab0AZPQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0AZPQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476Ab0AZPQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:16:52 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:34740 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754004Ab0AZPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:16:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=l5BYWrfLWsFCmb0oRl8i+GnN1ycj7HJWuoEEh/WjHSyuB6bziyHmi0clcCtGJEsCMgJKIURBJ+HPgs1WeAzsRclZwLHCpFsea9zekE/MFQr2c4112mHn11kDX2thDRoXqvHdYMiYSj1mr17vD2/n5S0T85pu++Wm65ntYlFgRVk=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: Gdv2YD4VM1l70jAS27zlIjoVAo59dVEbR_1kS.6XPXRy77g4Oy0Xxj5LkdkGuvIOe7LCjKSwdeL.wXejmi3gicjwPXPYd3CsIzJDP7LTttjSTS3xvU082KZMe0gZBCVmHq3YCfN7RZqiJttXHEh9g6rYIf0tJ0M0Kjhmqj65sb4Wupf0fdtlSiQkiPCAy5iTBMkCxk2ISxmNTMh.c5ixsoiPcFvEhjYkz1fChdreTWrmRZPH_zQtDZTO8fkzPSCA
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Tue, 26 Jan 2010 07:16:49 -0800
User-Agent: KMail/1.9.10
Cc: ext Oliver Neukum <oliver@neukum.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <201001261524.49661.oliver@neukum.org> <20100126143005.GI10690@nokia.com>
In-Reply-To: <20100126143005.GI10690@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001260716.49553.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Felipe Balbi wrote:
> but when suspended, we have to cut power ASAP. If not enumerated we can 
> still draw power for a few miliseconds due to dead battery provision.

When suspended, it's OK to draw a small amount of power.
On the order of one milliamp, based on the config that's
active ... instead of, often, hundreds.

That limit is why for example a PXA 255 could never get
certified as a bus-powered peripheral.  It required much
more than that when in suspend mode.

