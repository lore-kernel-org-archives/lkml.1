Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbXFZSa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbXFZSa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbXFZSas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:30:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49240 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699AbXFZSar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:30:47 -0400
Message-ID: <46815269.8060507@redhat.com>
Date: Tue, 26 Jun 2007 13:52:41 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Keith Chew <keith.chew@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: usb_fill_bulk_urb() broken for USB1.1?
References: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com>
In-Reply-To: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2007 10:20 AM, Keith Chew wrote:

[cc: linux-usb-devel]

> We have been using a Zydas based WIFI drivers under kernel 2.6.16.18
> with great success. Recently, when we upgraded to 2.6.20.1 (also
> tested on 2.6.21.5), we found that during initialisation, these calls
> works with USB2.0 but stopped working on USB1.1:
> 
> usb_fill_bulk_urb();
> usb_submit_urb();
> 
> The error code returned is -22 (-EINVAL). In 2.6.16.18, it works for
> both USB2.0 and 1.1.
> 
> When we change to use usb_fill_int_urb(), it then works for USB1.1,
> but takes up to 15 seconds (usually less than 5 seconds) for the
> driver to initialise. Also, usb_fill_int_urb() does not work for
> USB2.0 (kernel panic).
> 
> Can anyone point us to the right direction on how to get
> usb_fill_bulk_urb() working on USB1.1? We need this as not all of the
> deployed machines have USB2.0 enabled.
> 
