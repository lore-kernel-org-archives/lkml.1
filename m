Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZHCNWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZHCNWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZHCNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:22:36 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65364 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbZHCNWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sVdoygazramfaOpR7MujdwALjPXUIj070nu3qHmCX3X4W2IcD0ykoU4eCBOQuei6bQ
         zpIe6ezyF66bIYPS4/q1q2lX4D6V4Cl6RcVH11eLk6ys1mGTCNRAnYK1DbNR8l6gazwJ
         jG2AJO+WDFpdvzjyFL1RGzrM22+VPOzKFcCD8=
MIME-Version: 1.0
In-Reply-To: <200908031504.20506.oliver@neukum.org>
References: <81b0412b0908021339s739c07edvd4d5eb4c21cfa167@mail.gmail.com>
	 <81b0412b0908021409h73fc2fcfo64c4ba9ee1f0d552@mail.gmail.com>
	 <81b0412b0908030217o1e687c2ewf0191687a78d6166@mail.gmail.com>
	 <200908031504.20506.oliver@neukum.org>
Date: Mon, 3 Aug 2009 15:22:34 +0200
Message-ID: <81b0412b0908030622r7abce823l2b382a5f3b75f50b@mail.gmail.com>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its usb 
	interface from ACM to Ethernet
From: Alex Riesen <raa.lkml@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 15:04, Oliver Neukum<oliver@neukum.org> wrote:
> Am Montag, 3. August 2009 11:17:05 schrieb Alex Riesen:
>> 466             ep = (usb_pipein(acm->rx_endpoint) ? acm->dev->ep_in :
>> acm->dev->ep_out)
>> 467                             [usb_pipeendpoint(acm->rx_endpoint)];
>> 468             if (usb_endpoint_xfer_int(&ep->desc))
>>
>> So it looks like ep is NULL (usb_endpoint_xfer_int accesses
>> desc.bmAttributes, which is 3 bytes off the beginning of struct
>> usb_host_endpoint (desc being the first field in usb_host_endpoint).
>
> This tells you that the device has been disconnected. The question
> is not why this function fails, but why it is called even though the
> device has been disconnected.

Cool. How can I help?
