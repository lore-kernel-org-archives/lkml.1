Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbXF0HbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbXF0HbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbXF0Ha4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:30:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:31644 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbXF0Haz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ttv6QelKDQO1xQ0bLNmNYx5gHKAidTo7mGvPRgcTtL7/USLU55+FNasfkqLkiYx2bn5y/86WHK8NvAsWGnnnFC48NMXLby+U+AqQG+FWmSlrGmHZduPBHvXXwaoUwn2W6phAD8PuwEG63INTZikUECjrIfoABWYVmJB5vz7kqZc=
Message-ID: <20f65d530706270030y5650e302yc5136adc0ac8dd46@mail.gmail.com>
Date: Wed, 27 Jun 2007 19:30:53 +1200
From: "Keith Chew" <keith.chew@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [linux-usb-devel] usb_fill_bulk_urb() broken for USB1.1?
Cc: linux-usb-devel@lists.sourceforge.net, "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200706270827.50698.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com>
	 <46815269.8060507@redhat.com> <200706270827.50698.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver

>
> What do you use as arguments for usb_fill_bulk_urb() ? One of the sanity tests
> in usb_submit_urb() is triggered.
>

Usage:

	usb_fill_bulk_urb(macp->intr_urb, macp->usb,
		usb_rcvbulkpipe(macp->usb, EP_INT_IN),
		macp->IntEPBuffer, MAX_EPINT_BUFFER,
		zd1211_intr_cb, macp);

where

#define EP_INT_IN			0x03
#define MAX_EPINT_BUFFER	64

Here are the relevant structure definitions:

	struct usb_device	*usb;
	struct urb		*intr_urb;
	u8			*IntEPBuffer;

I can post the full structure if required.

Regards
Keith
