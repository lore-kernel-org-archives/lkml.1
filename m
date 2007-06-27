Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXF0G1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXF0G1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbXF0G1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:27:47 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:39709 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbXF0G1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:27:47 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] usb_fill_bulk_urb() broken for USB1.1?
Date: Wed, 27 Jun 2007 08:27:50 +0200
User-Agent: KMail/1.9.7
Cc: Chuck Ebbert <cebbert@redhat.com>, Keith Chew <keith.chew@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com> <46815269.8060507@redhat.com>
In-Reply-To: <46815269.8060507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706270827.50698.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Juni 2007 schrieb Chuck Ebbert:
> On 06/26/2007 10:20 AM, Keith Chew wrote:
> 
> [cc: linux-usb-devel]
> 
> > We have been using a Zydas based WIFI drivers under kernel 2.6.16.18
> > with great success. Recently, when we upgraded to 2.6.20.1 (also
> > tested on 2.6.21.5), we found that during initialisation, these calls
> > works with USB2.0 but stopped working on USB1.1:
> > 
> > usb_fill_bulk_urb();
> > usb_submit_urb();

What do you use as arguments for usb_fill_bulk_urb() ? One of the sanity tests
in usb_submit_urb() is triggered.

	Regards
		Oliver


