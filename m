Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYFEBHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYFEBHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYFEBGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:06:54 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53950 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760551AbYFEBGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:06:50 -0400
X-Sasl-enc: ZM8NNGve//JTfgVygM5zCdBkelQGHgdmP9oAc5P6YwgL 1212628009
Date: Wed, 4 Jun 2008 22:06:47 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>,
       Andrew Morton <akpm@osdl.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
	ACPI driver -- please review!
Message-ID: <20080605010647.GC16599@khazad-dum.debian.net>
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080604230326.GA30475@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604230326.GA30475@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008, Pavel Machek wrote:
> > > 3) Makes it possible to power the device off.
> 
> But this part is what I don't understand. powering off does not seem
> to belong there. Why can't you just use acpi to power down?

I think he means power down the g-sensors and related filters and A/D
circuitry.  The out-of-tree version of the HDAPS driver can do it as
well.

For what is it worth, I think drivers/accel is a good idea, and I think
the other accel drivers should be moved there.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
