Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbXKVLwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbXKVLwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 06:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXKVLwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 06:52:33 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:47976 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbXKVLwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 06:52:32 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: [linux-usb-devel] USB deadlock after resume
Date: Thu, 22 Nov 2007 12:52:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-usb-devel@lists.sourceforge.net,
       "Markus Rechberger" <mrechberger@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com> <d9def9db0711210725x3fe35fedlc67cf637bc9ad27f@mail.gmail.com> <200711212141.13102.laurent.pinchart@skynet.be>
In-Reply-To: <200711212141.13102.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711221252.34163.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 November 2007 schrieb Laurent Pinchart:
> I like the RESET_RESUME quirk best. Adding a new quirk to the uvcvideo driver 
> doesn't really make sense when the USB subsystem is already able to handle 
> this situation.

Not the driver but teh system wide quirks table. We have to reset such devices
even if no driver is loaded.

	Regards
		Oliver

