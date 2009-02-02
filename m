Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZBBBnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZBBBnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 20:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZBBBnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 20:43:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:28485 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZBBBnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 20:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SrCjNreJ/s9v8YROa1bK/bfcoPkAT+iATjSYVPixYT7HbcDO6AbOyBfQH45AddCEdp
         aDExbRPHltJY/dI2fCO1/sMQ9IE42dL8qXo9tamAu3gB3AI1IbekWAyqK4Jie8smk6or
         EiCSGzmKo6LdNH3Nc1zpYJAzH0lgP78B2RLCA=
MIME-Version: 1.0
In-Reply-To: <20090201155117.GA10018@kroah.com>
References: <49857F23.3090208@gmail.com> <20090201155117.GA10018@kroah.com>
Date: Mon, 2 Feb 2009 09:43:04 +0800
Message-ID: <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb-serial : fix the nousb oops
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: wgreathouse@smva.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 1, 2009 at 11:51 PM, Greg KH <greg@kroah.com> wrote:
> On Sun, Feb 01, 2009 at 06:53:23PM +0800, Dave Young wrote:
>>
>> In case with "nousb" booting, serial drivers will trigger kernel oops.
>
> They will?  What is the oops message?

Yes, they will, at lease I saw usb_serial/aircable/ftdi_sio oops. I
will manage to copy the oops message later.

>
>> Here add usb_disabled() check in usb_serial_init and usb_serial_register
>
> This is odd, is it something new?  Why is usb-serial the only driver
> that needs such a thing?

No, it is not new thing.  usb serial drivers normally call
usb_serial_register first, then usb_register, usb_register will fail
due to "nousb" checking, but usb_serial_register no.

>
> confused,
>
> greg k-h
>



-- 
Regards
dave
