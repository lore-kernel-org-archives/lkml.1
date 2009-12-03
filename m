Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZLCKwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZLCKwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZLCKwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:52:21 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44255 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518AbZLCKwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:52:19 -0500
X-Sasl-enc: hQ7nxUld36+0wwfePvGbXkclL2te1eu4hzmmpiwd5cOG 1259837546
Date: Thu, 3 Dec 2009 08:52:23 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Rafa?? Mi??ecki <zajec5@gmail.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Backlight device class redesign
Message-ID: <20091203105223.GB32571@khazad-dum.debian.net>
References: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
 <b170af450911291209o33ebfc36n850826e54096f3b4@mail.gmail.com>
 <1259827274.27069.50.camel@rzhang1-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259827274.27069.50.camel@rzhang1-desktop>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009, Zhang Rui wrote:
> For example, device /sys/class/backlight/panel0 is created the first
> time a backlight_ops for this display is registered.
> And create the symbol link from the backlight class device to "physical
> device" (device that invokes backlight_device_register) in the backlight
> class device driver, if we really need it.
> Remove and recreate a link pointing to the new physical device when the
> backlight mode is changed.

FWIW, I agree the above solution is simple enough and quite good enough.

I just have absolutely _NO_ idea whatsoever how a platform driver can ask
the PCI or APCI layer "where is the video device driving the LVDS panel so
that I can bind to it"...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
