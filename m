Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYACDCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYACDCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYACDCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:02:09 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:23261 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYACDCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:02:08 -0500
X-IronPort-AV: E=Sophos;i="4.24,237,1196658000"; 
   d="scan'208";a="46102860"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Wed, 2 Jan 2008 22:03:04 -0500
User-Agent: KMail/1.9.5
Cc: linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <200801020948.51310.rgetz@blackfin.uclinux.org> <200801021047.16036.david-b@pacbell.net>
In-Reply-To: <200801021047.16036.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801022203.04991.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 03 Jan 2008 03:02:05.0940 (UTC) FILETIME=[05A86340:01C84DB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2 Jan 2008 13:47, David Brownell pondered:
> On Wednesday 02 January 2008, Robin Getz wrote:
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > Allow embedded developers to turn support for USB Hubs off even if
> > they have a full root hub. This saves the overhead (RAM and Flash size).
> 
> ISTR that it won't save very much code though ... the Linux USB
> stack structures all its enumeration logic around hubs.

Today, there is an USB (Host), USB_GADGET and USB_OTG (which depends on USB && 
USB_GADGET).

This just enables cutting more code out, with out having to have USB_GADGET & 
USB_OTG enabled. When I checked - that is where most of the savings came 
from.

-Robin
