Return-Path: <linux-kernel-owner+w=401wt.eu-S932448AbZKMX13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbZKMX13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932405AbZKMX1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:27:24 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50298 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbZKMX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TqFrRIOksg4lg3tgyk41mV4ulRP67xPiifDXFzJNIam81BcKHRZLTV1Ta1J+7LbgNW
         d5T6J4zfD6jP6C0VK8MzLjEFXtPvVhnh3w46wtOlaOscO0X5xO/1uWgbTn79nm03WGwM
         hBA+CjYoaMieLDiCVP63Dy9UVrYEMmHDmOWYo=
Message-ID: <4AFDEB57.2050908@gmail.com>
Date: Fri, 13 Nov 2009 17:27:19 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with p55-express and sleeping usb-hds
References: <4AFDDDF6.4050907@ahsoftware.de>
In-Reply-To: <4AFDDDF6.4050907@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 04:30 PM, Alexander Holler wrote:
> Hello,
>
> I'm having a problem with kernels (x86_64) <=2.6.32-rc7 (that means all
> kernels I tried, including the latest stable 2.6.31.6) on a Gigabyte
> P55M-UD4 mb (Bios F4l) with an Intel Core i7 860 and sleeping usb-hds.
>
> I don't have the problems when using the same usb-drives on a laptop
> with a core2duo (ICH8), so it seems to be a problem with the chipset
> (p55-express).
>
> The problem seems to occur when the usb-drive goes to sleep (because of
> inactivity) and the kernel tries to access them afterwards.
>
> Here are the excerpts from the log:
>
> ...
>
> (And here comes the problem)>
> Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed
> USB device using ehci_hcd and address 3
> Nov 13 19:47:39 krabat kernel: [ 2661.120397] usb 9-7: device firmware
> changed
> Nov 13 19:47:39 krabat kernel: [ 2661.120489] usb 9-7: USB disconnect,
> address 3

That sounds like the device started reporting a different firmware 
string after it woke up, and the kernel decided it wasn't the same 
device anymore and triggered a disconnect/reconnect..
