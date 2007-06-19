Return-Path: <linux-kernel-owner+w=401wt.eu-S1764276AbXFSS5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764276AbXFSS5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763836AbXFSS5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:57:14 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:53235 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763006AbXFSS5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:57:13 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Paul Walmsley <paul@booyaka.com>
Subject: Re: [linux-usb-devel] Error -71 on device descriptor read/all
Date: Tue, 19 Jun 2007 20:56:50 +0200
User-Agent: KMail/1.9.7
Cc: linux-usb-devel@lists.sourceforge.net, Chuck Ebbert <cebbert@redhat.com>,
       "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       linux-kernel@vger.kernel.org
References: <4677EBF8.5020104@mandic.com.br> <200706191902.08173.oliver@neukum.org> <Pine.LNX.4.64.0706191134160.12843@utopia.booyaka.com>
In-Reply-To: <Pine.LNX.4.64.0706191134160.12843@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706192056.50656.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Juni 2007 schrieb Paul Walmsley:
> On Tue, 19 Jun 2007, Oliver Neukum wrote:
> 
> > Am Dienstag, 19. Juni 2007 schrieb Chuck Ebbert:
> >
> >> Try disabling CONFIG_USB_SUSPEND
> >>
> >> [usb developers: what are the drawbacks of doing this?]
> >
> > Increased power consumption.
> 
> speaking of CONFIG_USB_SUSPEND, I've encountered at least one device -- a 
> Canon EOS 5D camera -- that, after the bus suspends, must be powercycled 
> in order to return the camera's interrupt endpoints to a functional state. 
> How are these types of problems handled, currently?  Is this something for 
> a blacklist?

drivers/usb/core/quirks.c

Please try the reset-resume quirk before you use the no-autosuspend quirk.

	Regards
		Oliver

