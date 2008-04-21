Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYDUXFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYDUXFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYDUXFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:05:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:32273 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYDUXFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=x+9UPD3n1guFX3ICJ2BTbfOr8evZchQw48LEAC+HG60oWl/TMJJ9dLtBG4gLhNRIGf+A4Y1AwHQbQ+PMuXS9uZCrmsI2xR13WG2dUYetfuflsDKw9W0oL/2Lmn0lTpUwAPI2txyIR2tRXUxPmO11ZN/UEJT9yN00O8OlL9uA1Wo=
Message-ID: <480D1DB8.20109@gmail.com>
Date: Tue, 22 Apr 2008 01:05:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Anssi Hannula <anssi.hannula@gmail.com>,
       linux-input@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       mit-devel@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: HID bus
References: <Pine.LNX.4.64.0804181333180.12972@jikos.suse.cz> <1208644696-29129-1-git-send-email-jirislaby@gmail.com> <480B6C16.40806@gmail.com> <Pine.LNX.4.64.0804211124060.19002@twin.jikos.cz> <20080421133621.GA27646@anvil.corenet.prv>
In-Reply-To: <20080421133621.GA27646@anvil.corenet.prv>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2008 03:36 PM, Dmitry Torokhov wrote:
> On Mon, Apr 21, 2008 at 11:25:43AM +0200, Jiri Kosina wrote:
>> On Sun, 20 Apr 2008, Anssi Hannula wrote:
>>
>>> Why not just do something like
>>>
>>> #define HID_DEVICE(vend, dev) \
>>> 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
>>> 		       USB_DEVICE_ID_MATCH_INT_CLASS, \
>>> 	.idVendor = (vend), \
>>> 	.idProduct = (prod), \
>>> 	.bInterfaceClass = USB_INTERFACE_CLASS_HID
>>> (see linux/usb.h)
>>>
>>> and use USB hotplugging?
>>> Or do we plan to match against something else as well, such as hid
>>> reports or something?
>> No, we plan to do matching based solely on VID/PID. The report-specific 
>> stuff is then handled between the specific driver and HID generic code.
>>
> 
> Hmm, [ab]using USB modalias makes me a bit uneasy. What about bluetooth
> HID devices?

I do agree, it won't be nice and abstract enough. Working on it, give me some 
time, please.
