Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbYGGSLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbYGGSLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYGGSLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:11:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:56327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYGGSLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:11:19 -0400
From: Matthias Geissert <matthias.geissert@web.de>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [Bug 10868] Oops on loading ipaq module since 2.6.26, prevents use of device
Date: Mon, 7 Jul 2008 20:16:02 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, Adam Williamson <awilliamson@mandriva.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <20080703085733.GB11254@cs181140183.pp.htv.fi> <200807031608.46457.oliver@neukum.org>
In-Reply-To: <200807031608.46457.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072016.02979.matthias.geissert@web.de>
X-Provags-ID: V01U2FsdGVkX1/5AVxTJaTPGvem/G3t6ERutunk768e9UztuV7
 JZoImvPmpzBKSXEeaV928urwEh3rBuJBigvWfC/Xa/Kkp35JKk
 6Y0Wf0B5SFeCsGIYbyAmRthY8vZJz3+7vyabTAkpakOmUAcjHQ
 Jqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. Juli 2008 16:08:44 schrieb Oliver Neukum:


> >  	.num_interrupt_in =	NUM_DONT_CARE,
> > -	.num_bulk_in =		1,
> > -	.num_bulk_out =		1,
> > -	.num_ports =		1,
> > +	.num_bulk_in =		NUM_DONT_CARE,
> > +	.num_bulk_out =		NUM_DONT_CARE,
>
> This is good.
>
> > +	.num_ports =		2,
>
> This is fatal.

I checked what you said with kernel 2.6.26 rc9.  I set num_ports to 5. It 
worked quite well until I tried to connect to a non-existing endpoint. 

However, the problem is that the Yakumo Delta needs to connect to the 2nd 
endpoint. You can connect to the first one but you don't get any data. 

Is there any good way to tell the ipaq driver to use the 2nd endpoint? Maybe 
one could provide a different struct usb_serial_driver ipaq_device depending 
on the usb id or an option which tells the driver to use 2 endpoints.

Regards,
matthias  
