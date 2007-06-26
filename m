Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbXFZT3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbXFZT3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759363AbXFZT3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:29:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34786 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759302AbXFZT33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:29:29 -0400
Date: Tue, 26 Jun 2007 12:30:57 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Keith Chew <keith.chew@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: usb_fill_bulk_urb() broken for USB1.1?
Message-Id: <20070626123057.d659a62e.zaitcev@redhat.com>
In-Reply-To: <46815269.8060507@redhat.com>
References: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com>
	<46815269.8060507@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 13:52:41 -0400, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 06/26/2007 10:20 AM, Keith Chew wrote:

> [cc: linux-usb-devel]
> 
> > We have been using a Zydas based WIFI drivers under kernel 2.6.16.18
> > with great success. Recently, when we upgraded to 2.6.20.1 (also
> > tested on 2.6.21.5), we found that during initialisation, these calls
> > works with USB2.0 but stopped working on USB1.1:
> > 
> > usb_fill_bulk_urb();
> > usb_submit_urb();
> > 
> > The error code returned is -22 (-EINVAL). In 2.6.16.18, it works for
> > both USB2.0 and 1.1.

This looks like an attempt to submit a bulk URB to an interrupt endpoint,
with garbage interval or something of that nature.

I think it would be the best to talk to the driver author directly.

-- Pete
