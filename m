Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYL2Ut2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYL2Ut2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYL2UtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:49:15 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:6177 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYL2UtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:49:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V9nRphK7Aii+WI9qXjtt21xNbktZsfOao9CS81qygdgqHrks2fybPbk0QT9rH1gSml
         5SaOvw/GjdrX/y9a/L/xknsID+jqrdaBxXu70UowTjp8yM10eI5TMPKtuSwv0Q6dEUpI
         Ns1gX6D205MC/wXPyC/gic6cun3S63vcsQXcQ=
Message-ID: <495937C3.7090101@gmail.com>
Date: Mon, 29 Dec 2008 12:49:07 -0800
From: John Daiker <daikerjohn@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20081204 Lightning/1.0pre Thunderbird/3.0b1
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Alan Stern <stern@rowland.harvard.edu>, Julia Lawall <julia@diku.dk>,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather
 than constants
References: <Pine.LNX.4.44L0.0812291452580.1979-100000@iolanthe.rowland.org> <200812291222.48966.david-b@pacbell.net>
In-Reply-To: <200812291222.48966.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2008 12:22 PM, David Brownell wrote:

> On Monday 29 December 2008, Alan Stern wrote:
>    
>> On Mon, 29 Dec 2008, David Brownell wrote:
>>
>>      
>>> Those functions were supposed to go into<linux/usb/ch9.h>, as
>>> I recall, since they weren't specific to the host side stack.
>>>
>>> Having them added to the wrong file is surely part of why
>>> they've only been used by host side drivers.  :)
>>>        
>> Would you like to write a patch moving the functions to ch9.h?  Or
>> would you like to ask Julia or me to do it?
>>      
>
> Someone other than me.  ;)
>
> Maybe someone on K-J will want to volunteer with a patch
> before either you or Julia...
>
> - Dave
>    
So you're saying that these functions:
usb_endpoint_dir_in(epd)
usb_endpoint_dir_out(epd)
usb_endpoint_is_bulk_in(epd)
usb_endpoint_is_bulk_out(epd)
usb_endpoint_is_int_in(epd)
usb_endpoint_is_int_out(epd)
usb_endpoint_num(epd)
usb_endpoint_type(epd)
usb_endpoint_xfer_bulk(epd)
usb_endpoint_xfer_control(epd)
usb_endpoint_xfer_int(epd)
usb_endpoint_xfer_isoc(epd)

Should be defined in ch9.h instead of usb.h?

If that's the case, then I'll be glad to cook up a patch! :)

~John

