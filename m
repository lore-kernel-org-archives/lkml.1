Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbZCRO3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbZCRO3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZCRO3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:29:44 -0400
Received: from billgribble.com ([65.99.215.30]:59330 "EHLO
	mail.billgribble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZCRO3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:29:43 -0400
Subject: Re: usbhid:  Changes since 2.6.28 in quirk handling?
From: Bill Gribble <grib@billgribble.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0903181511010.12145@wotan.suse.de>
References: <1236947942.9606.26.camel@localhost>
	 <alpine.LNX.2.00.0903181511010.12145@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 10:29:07 -0400
Message-Id: <1237386547.4954.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar 18 09:30:48 2009
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 49c1059813714004923371
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 15:14 +0100, Jiri Kosina wrote:
> we have drivers (and even whole architectures) supported by the kernel, 
> which have less than 5 users in the world, that's not a big deal.

Great to hear that!  I will try to clean up my patches according to the
guidelines and send them in.  

> Looking at your patch, the only thing you need is sending a special URB to 
> the device in order to make it operational, right?

That's right. 

> Please look at hid-sony driver, which does exactly that for some of the 
> PS3 devices.
> 
> You then only need to add your device to hid_blacklist[], so that generic 
> driver doesn't get bound to it and it'd be driven by your special driver.

OK, thanks for the advice.  I will do that. 

Bill Gribble


