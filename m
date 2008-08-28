Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYH1Q7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYH1Q7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYH1Q7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:59:08 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:53521 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYH1Q7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:59:07 -0400
From: Marcel Janssen <korgull@home.nl>
Reply-To: korgull@home.nl
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Thu, 28 Aug 2008 18:58:41 +0200
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <20080827183615.GA15692@kroah.com> <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org> <20080827234720.GC31264@kroah.com>
In-Reply-To: <20080827234720.GC31264@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281858.42486.korgull@home.nl>
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 01:47:20 Greg KH wrote:
> Great, all done now.
>
> Here's the updated version.

I've just installed this version.

Here's what I see so far :

The driver inserts well and when I connect my device it shows /dev/usbtmc0 
with major 180 and minor 176.
It only creates one device (Stefan's driver created two) but I'm not sure if 
that has changed for a reason so just let you know.

When I disconnect my device, usbtmc0 will not be destroyed. After connecting 
the device a couple of times I have a lot of /dev/usbtmc.. files.

I would expect the following to work :
echo :*IDN?>/dev/usbtmc0
But it returns : No such device

Using echo and cat to test the device is quite convenient, but is this 
supposed to work yet ?

I checked /sys a bit and found that the endpoints are correctly found.    

I also had an issue applying the patch (documentation and makefile). Not sure 
if that's related to my system though, I'll check that later.

regards,
Marcel


