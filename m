Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYL2VB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYL2VB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYL2VBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:01:14 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30589 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751829AbYL2VBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:01:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SM7GH+54iDrqiFPpJT459/9HJSdOG8r9aDwxqrEtZpv4CPCCYelbf3LKrrYGnG+rSiHzcVyg3vijQQpy2QHJykKmQ0ZIUvzzsNiJJl4bMeiWwa+RYo6tZ1TRBr1dMGqFtAOzkb80/aZsJZHGg6GaP9WGvA4pPnIUQ96MT1pkDZo=  ;
X-YMail-OSG: Otmn4VkVM1lBuuXEZbUso57cBajFpyQDdjflJbwb9dtLxBWAXgW8NSKiMp04xhFSiPT4vVAsmBT87XFQcLwsYIBY8nEOEVI5epPi8tZJzT407bN6CHs6LWRILQFbt6eF4Dm2JGsWZicn7jEe_zmE3gqC
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: John Daiker <daikerjohn@gmail.com>
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather than constants
Date: Mon, 29 Dec 2008 13:01:11 -0800
User-Agent: KMail/1.9.10
Cc: Alan Stern <stern@rowland.harvard.edu>, Julia Lawall <julia@diku.dk>,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.44L0.0812291452580.1979-100000@iolanthe.rowland.org> <200812291222.48966.david-b@pacbell.net> <495937C3.7090101@gmail.com>
In-Reply-To: <495937C3.7090101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812291301.11438.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008, John Daiker wrote:
> So you're saying that these functions:
> usb_endpoint_dir_in(epd)
> usb_endpoint_dir_out(epd)
> usb_endpoint_is_bulk_in(epd)
> usb_endpoint_is_bulk_out(epd)
> usb_endpoint_is_int_in(epd)
> usb_endpoint_is_int_out(epd)
> usb_endpoint_num(epd)
> usb_endpoint_type(epd)
> usb_endpoint_xfer_bulk(epd)
> usb_endpoint_xfer_control(epd)
> usb_endpoint_xfer_int(epd)
> usb_endpoint_xfer_isoc(epd)
> 
> Should be defined in ch9.h instead of usb.h?

Also usb_endpoint_is_isoc_{in,out}() ...

 
> If that's the case, then I'll be glad to cook up a patch! :)

I think Julia just signed up for that ...

- Dave

