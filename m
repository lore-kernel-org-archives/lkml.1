Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYGCO0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYGCO0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYGCO0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:26:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37398 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYGCO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:26:20 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [Bug 10868] Oops on loading ipaq module since 2.6.26, prevents use of device
Date: Thu, 3 Jul 2008 16:26:48 +0200
User-Agent: KMail/1.9.9
Cc: Adam Williamson <awilliamson@mandriva.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Matthias Geissert <matthias.geissert@web.de>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200807031608.46457.oliver@neukum.org> <20080703142025.GC11254@cs181140183.pp.htv.fi>
In-Reply-To: <20080703142025.GC11254@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031626.50531.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 03 Juli 2008 16:20:30 schrieb Adrian Bunk:
> On Thu, Jul 03, 2008 at 04:08:44PM +0200, Oliver Neukum wrote:
> > Am Donnerstag 03 Juli 2008 10:57:33 schrieb Adrian Bunk:

> > > --- a/drivers/usb/serial/ipaq.c
> > > +++ b/drivers/usb/serial/ipaq.c
> > > @@ -571,9 +571,9 @@ static struct usb_serial_driver ipaq_device = {
> > >  	.usb_driver = 		&ipaq_driver,
> > >  	.id_table =		ipaq_id_table,
> > >  	.num_interrupt_in =	NUM_DONT_CARE,
> > > -	.num_bulk_in =		1,
> > > -	.num_bulk_out =		1,
> > > -	.num_ports =		1,
> > > +	.num_bulk_in =		NUM_DONT_CARE,
> > > +	.num_bulk_out =		NUM_DONT_CARE,
> > 
> > This is good.
> 
> These fields are removed by a later commit in 2.6.26...  8-)

Well, NUM_DONT_CARE is default, so it makes no difference, but a comment
would have been nice.

	Regards
		Oliver


