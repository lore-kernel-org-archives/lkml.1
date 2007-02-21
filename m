Return-Path: <linux-kernel-owner+w=401wt.eu-S1945899AbXBUW7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945899AbXBUW7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945903AbXBUW7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:59:49 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:44077 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945899AbXBUW7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:59:48 -0500
Subject: Re: Phis in /proc/bus/input/devices same for all devices?
From: Marcel Holtmann <marcel@holtmann.org>
To: CIJOML <cijoml@volny.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200702212354.38618.cijoml@volny.cz>
References: <200702212313.30359.cijoml@volny.cz>
	 <1172097890.7403.52.camel@violet>
	 <d120d5000702211448s7d3569cdl1fdcb71d13c3c3ff@mail.gmail.com>
	 <200702212354.38618.cijoml@volny.cz>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 00:00:29 +0100
Message-Id: <1172098829.7403.58.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> I need this for differing Option "XkbModel" in Xorg, so I can bind to each
> device it's model and has correct xev's scancodes based on model.
> So I prefer to have as Phis just only BDADDR, because for me this doesn't make 
> sense to have there device to which keyboard connect. Then I should have 1 
> section for each receiver, which is stupid.

it makes sense to make it analogous to the USB driver, where the phys
includes the USB path. The equivalent for Bluetooth is the source plus
destination.

> Section "InputDevice"
>         Identifier  "Bluetooth Keyboard"
>         Driver      "kbd"
>         Option  "Name"  "Bluetooth HID Boot Protocol Device"
>         Option  "Phis"        "BDADDR"
>         Option      "XkbRules"  "xfree86"
>         Option      "XkbModel"  "dinovo"
>         Option      "XkbLayout" "us"
> EndSection

I don't know how "Phis" suppose to work, but I might think it is better
using vendor and product ID for matching.

Regards

Marcel


