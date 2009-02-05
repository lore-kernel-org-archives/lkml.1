Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbZBEJd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbZBEJd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZBEJdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:33:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:36084 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZBEJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:33:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=blR4puUD0FB5UiRJ3KAdiyVoB4pRkA4ZZZR/uhTJo9VcoTXLkUkwM5+thzpXK0YHW5
         lE4W6Hno58rsPdwW2wm6Z6iMgWzkAMcwAZ6WC3i18Im/WR1W3Pa3/fOBxEJ3IRev21bE
         yXEMlLzw7KhOEjJtdwgZUfssooq6YoiqQBmUs=
MIME-Version: 1.0
In-Reply-To: <20090204235949.GA300@kroah.com>
References: <49857F23.3090208@gmail.com> <20090201155117.GA10018@kroah.com>
	 <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com>
	 <20090203235814.GA22380@kroah.com>
	 <a8e1da0902031710u2ebd69b0r4de5916fab2d3cba@mail.gmail.com>
	 <20090204235949.GA300@kroah.com>
Date: Thu, 5 Feb 2009 17:33:08 +0800
Message-ID: <a8e1da0902050133n5cc5db62j4a48cd1ea32442b2@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb-serial : fix the nousb oops
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 7:59 AM, Greg KH <greg@kroah.com> wrote:
> On Wed, Feb 04, 2009 at 09:10:20AM +0800, Dave Young wrote:
>> remove wgreathouse@smva.com in cc-list because this mail will be
>> rejected by the smva.com email server.
>>
>> On Wed, Feb 4, 2009 at 7:58 AM, Greg KH <greg@kroah.com> wrote:
>> > On Mon, Feb 02, 2009 at 09:43:04AM +0800, Dave Young wrote:
>> >> On Sun, Feb 1, 2009 at 11:51 PM, Greg KH <greg@kroah.com> wrote:
>> >> > On Sun, Feb 01, 2009 at 06:53:23PM +0800, Dave Young wrote:
>> >> >>
>> >> >> In case with "nousb" booting, serial drivers will trigger kernel oops.
>> >> >
>> >> > They will?  What is the oops message?
>> >>
>> >> Yes, they will, at lease I saw usb_serial/aircable/ftdi_sio oops. I
>> >> will manage to copy the oops message later.
>> >>
>> >> >
>> >> >> Here add usb_disabled() check in usb_serial_init and usb_serial_register
>> >> >
>> >> > This is odd, is it something new?  Why is usb-serial the only driver
>> >> > that needs such a thing?
>> >>
>> >> No, it is not new thing.  usb serial drivers normally call
>> >> usb_serial_register first, then usb_register, usb_register will fail
>> >> due to "nousb" checking, but usb_serial_register no.
>> >
>> > But as usb_register will fail, shouldn't they properly back out and no
>> > oopses happen?  This sounds like a simple fix to the drivers that are
>> > failing here, not changing the usb-serial core.
>>
>> Hi greg
>>
>> I think all usb serial drivers which call usb_serial_register will
>> oops, so IMHO usb core should be fixed.
>>
>> I think maybe you missed my another reply, copy the content here again.
>
> No, I got it.
>
> I'm more interested in why usb-serial is oopsing, as it should't be.
>
>> ---
>> hand copy part of the oops message:
>
> Can you take a picture of the oops?

Hi, I have no camera at hand, I will take the picture tomorrow.

>
> thanks,
>
> greg k-h
>



-- 
Regards
dave
