Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYEOJLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYEOJLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYEOJLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:11:03 -0400
Received: from senator.holtmann.net ([87.106.208.187]:53508 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYEOJLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:11:02 -0400
Subject: Re: [PATCH 2/9] HID: make a bus from hid code
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, akpm@linux-foundation.org,
       Jiri Slaby <jslaby@suse.cz>
In-Reply-To: <482AB12F.20106@gmail.com>
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-2-git-send-email-jirislaby@gmail.com>
	 <1210547158.16390.28.camel@violet.holtmann.net>  <482AB12F.20106@gmail.com>
Content-Type: text/plain
Date: Thu, 15 May 2008 11:11:02 +0200
Message-Id: <1210842662.7025.21.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> >> +static struct hid_driver hid_generic_bt = {
> >> +	.name = "hid-generic-bt",
> >> +	.id_table = hid_generic_bt_ids,
> >> +};
> > 
> > And this one to hidp_driver instead of hid_generic_bt.
> > 
> > Also the name "hid-generic-bt" is not okay. Call it "hidp" since that is
> > the driver name. An alternative would be "hid-bluetooth". I don't like
> > the "generic" part and we never used the shortcut "bt" in any sysfs
> > visible file.
> 
> Thanks for comments, I fixed all those except this one. The generic- word is 
> tested in the core to recognize generic drivers which bind non-blacklisted 
> devices and are handled separately. Anyway I've renamed them to 
> generic-bluetooth and generic-usb instead of hid-generic-{bt,usb}.
> 
> I think the generic word in the driver name is OK, so that one ordinary user 
> can see, my device is handled by the generic driver without special 
> processing. Would you rather see some flag or something?

actually generic-usb and generic-bluetooth sound perfectly fine to me.

Regards

Marcel


