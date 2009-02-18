Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZBRREn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZBRREn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZBRREc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:04:32 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:50562 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZBRREb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:04:31 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: USB mouse won't work after resume.
Date: Wed, 18 Feb 2009 18:06:17 +0100
User-Agent: KMail/1.9.10
Cc: Laurent Riffard <laurent.riffard@free.fr>, linux-input@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0902181150370.17341-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902181150370.17341-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902181806.18622.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 18 February 2009 17:51:29 schrieb Alan Stern:
> On Tue, 17 Feb 2009, Oliver Neukum wrote:
> 
> > Am Tuesday 17 February 2009 14:37:04 schrieb Laurent Riffard:
> > > Le 17.02.2009 11:35, Oliver Neukum a écrit :
> > > > Am Tuesday 17 February 2009 10:55:57 schrieb Laurent Riffard:
> > > >> My USB mouse won't work after suspend to disk and resume. I must unload and reload the ohci_hcd module to get it back.
> > > > 
> > > > Please recompile your kernel with CONFIG_USB_DEBUG and
> > > > send me your dmesg.
> > > > 
> > > > 	Regards
> > > > 		Oliver
> > > > 
> > > 
> > > Here is it:
> > > 
> > 
> > Please try the attached patch.
> 
> By the way, have you tested to see if the post_reset method needs an 
> equivalent change?

How could that be? usb_reset_device() refuses to work on a suspended
device.

	Regards
		Oliver
