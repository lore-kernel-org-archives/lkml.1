Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYERJji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYERJji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 05:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYERJjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 05:39:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:19997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYERJja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 05:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iNEhoILV87Qq6nDU6gbfv2oEnNfkLZIRSmF9vmqnPnPfXm03AdZ0JvZcFOxn44vPZ1Vr6+WkmmeA2icTgJdWzpCSfpHKR/qcHnaSJ3oSwUSRmjIvNkAOIy0fPV/4I4lEkKgXkVi4/yhR2me+ilgrd0+Fp13kU6tosjanWXz8dnQ=
Message-ID: <84144f020805180239t4c4952e6i7dcaa224a53bebb7@mail.gmail.com>
Date: Sun, 18 May 2008 12:39:29 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pau Oliva Fora" <pau@eslack.org>
Subject: Re: [PATCH] Add support for HTC Shift Touchscreen
Cc: dmitry.torokhov@gmail.com, sam@ravnborg.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <482F09FC.9050403@eslack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482ED31E.2000009@eslack.org> <482F09FC.9050403@eslack.org>
X-Google-Sender-Auth: 2339f58f303763e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 7:38 PM, Pau Oliva Fora <pau@eslack.org> wrote:
>>> +struct input_dev *htcpen_dev;
>>
>> Why are you not using isa_register_driver() instead?
>
> I have no specifications from the manufacturer, so don't know how to
> properly prove the device, etc.

You can still use isa_register_driver() which is nicer IMHO.

On Sat, May 17, 2008 at 7:38 PM, Pau Oliva Fora <pau@eslack.org> wrote:
>>> +       printk(KERN_INFO "htcpen: module inserted\n");
>>> +
>>> +       inb_p(HTCPEN_PORT0);
>>
>> So there's no way to probe the existence of this device?
>
> I can add a minimal sanity check if that is a must, but I don't have
> a datasheet and contacting HTC did not help.

Well, you probably want distributions to be able to enable this by
default so any kind probing is helpful, yes.
