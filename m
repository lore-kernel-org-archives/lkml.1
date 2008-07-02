Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYGBVdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYGBVdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbYGBVc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:32:59 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:39022 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbYGBVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:32:57 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents use of device
Date: Wed, 2 Jul 2008 23:33:23 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200806301509.09013.oliver@neukum.org> <1215031257.6054.201.camel@lenovo.local.net>
In-Reply-To: <1215031257.6054.201.camel@lenovo.local.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807022333.25275.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 02 Juli 2008 22:40:57 schrieb Adam Williamson:
> On Mon, 2008-06-30 at 15:09 +0200, Oliver Neukum wrote:
> > Am Freitag 27 Juni 2008 21:28:54 schrieb Adam Williamson:
> > > On Wed, 2008-06-25 at 17:41 +0200, Oliver Neukum wrote:
> > > > Am Mittwoch 25 Juni 2008 04:05:13 schrieb Adam Williamson:
> > > > > On Mon, 2008-06-23 at 20:41 +0200, Oliver Neukum wrote:
> > > > > 
> > > > > > It is the module option "debug" for usb-serial.
> > > > > 
> > > > > OK, here you go:
> > > > 
> > > > Please also set the debug module parameter for the ipaq module.
> > > 
> > > OK.
> > 
> > Your device is considered to have two ports but not enough endpoints.
> > Please provide the output of "lsusb -v"
> 
> Here's the lsusb stanza for the device.

This is odd. Your device shows one interface with one endpoint bulk and
bulk out respectively. Yet two ports are created. Odd.

	Regards
		Oliver

