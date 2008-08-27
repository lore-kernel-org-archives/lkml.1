Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYH0TEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYH0TEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYH0TEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:04:37 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55937 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYH0TEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:04:36 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Wed, 27 Aug 2008 21:05:49 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808272105.50169.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 27 August 2008 20:58:08 schrieb Alan Stern:
> > And this rule depends on sharing the USB major or not. This needs
> > a big fat mention in Documentation.
> 
> You mean that the open/disconnect locking rule applies only to drivers 
> that call usb_register_dev, i.e, drivers using the USB major.  Right?

Yes. In fact drivers not using the USB major but their own char devices
will need such a lock. This is tricky.

> I agree that it deserves to be mentioned in the documentation 
> somewhere.  Where would be a good place?  None of the existing files in 
> Documentation/usb seem appropriate.

The USB major merits a file of its own.

	Regards
		Oliver
