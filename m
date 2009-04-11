Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbZDKRe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbZDKRe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 13:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZDKReB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 13:34:01 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:39203 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453AbZDKReA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 13:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=iwLZ7EGCtyOkl+6eKQpS2rv4P03g3gNQbQRIHAD8jejPB1ZMuIkLOeaZUpFcyyZIwN
         Z7ULKLvQR97qrujcGBqpziutevA7LWA39d14bBxfLWhHXAXNZtFZolS+Ym6GW+OUFjpn
         pUPfsAP8IHly04IPtlsvbNiPWN8SD2ZjnO4TQ=
Message-ID: <49E0D483.9040907@gmail.com>
Date: Sat, 11 Apr 2009 11:33:55 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Robert Mykland <robert@ascenium.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: USB auto mount - specific versus general driver
References: <49E0127D.7030206@ascenium.com>
In-Reply-To: <49E0127D.7030206@ascenium.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Mykland wrote:
> Folks,
> 
> Consider a USB key that auto mounts as a generic USB storage device 
> using the block level driver for that.  Can I write a driver that, for 
> example, is more specific to that key and gets loaded and used at auto 
> mount time instead of the generic driver?  How would I go about 
> identifying my driver so it superseded the generic one?

You'd have to add an unusual device entry to the USB storage driver 
which tells it not to claim that device. Look at 
drivers/usb/storage/unusual_devs.h and the US_FL_IGNORE_DEVICE flag.

> 
> Thanks in Advance,
> 
> -- Robert.
> 

