Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYFKSYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYFKSYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYFKSYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:24:03 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:36526 "EHLO
	jenni2.rokki.sonera.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751309AbYFKSYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:24:01 -0400
Message-ID: <4850183B.90609@gmail.com>
Date: Wed, 11 Jun 2008 21:23:55 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] HID: move logitech report quirks
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com> <1210931362-18422-2-git-send-email-jirislaby@gmail.com> <1210931362-18422-3-git-send-email-jirislaby@gmail.com> <1210931362-18422-4-git-send-email-jirislaby@gmail.com> <1210931362-18422-5-git-send-email-jirislaby@gmail.com> <1210931362-18422-6-git-send-email-jirislaby@gmail.com> <Pine.LNX.4.64.0806041520140.10085@jikos.suse.cz> <484D070E.9050707@gmail.com> <Pine.LNX.4.64.0806111611540.10085@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0806111611540.10085@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 9 Jun 2008, Jiri Slaby wrote:
> 
>>>> static const struct hid_device_id hid_blacklist[] = {
>>>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
>>>> USB_DEVICE_ID_MX3000_RECEIVER) },
>>>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER)
>>>> },
>>>> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
>>>> USB_DEVICE_ID_S510_RECEIVER_2) },
>>>>  	{ }
>>>>  };
>>> This shouldn't be needed as soon as the userspace supports the proper module
>>> autoloading, right?
>> This is needed to tell generic drivers not to bind these, its' generic
>> blacklist. I have no idea how this could be done better with current
>> drivers/base/.
> 
> Hmm ... but if we make sure that the order in `modules.order' puts all the 
> specialized drivers before the generic one, the binding should be done 
> correctly even without blacklist, right?

A little off-topic, but is there a module-init-tools repository with
modules.order handling somewhere, or does it (still) only exist as
not-yet-integrated patches?

-- 
Anssi Hannula
