Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbYEOUaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbYEOUaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYEOUaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:30:09 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:44527
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYEOUaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:30:08 -0400
Subject: Re: Virt RNG?
From: Dor Laor <dor.laor@qumranet.com>
Reply-To: dor.laor@qumranet.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeff Garzik <jeff@garzik.org>, virtualization@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <482C94AF.2010202@goop.org>
References: <482C8595.5030509@garzik.org>  <482C94AF.2010202@goop.org>
Content-Type: text/plain
Organization: Qumranet
Date: Thu, 15 May 2008 23:26:18 +0300
Message-Id: <1210883178.24261.914.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-15 at 20:53 +0100, Jeremy Fitzhardinge wrote:
> Jeff Garzik wrote:
> > Has anyone yet written a "hw" RNG module for virt, that reads the host's 
> > random number pool?
> >
> > All this talk[1] about IRQF_SAMPLE_RANDOM in network drivers reminds me 
> > that virt guest instances should be grabbing random numbers from the 
> > host, especially if the host has a hardware RNG.
> 
> It was actually one of the first device types proposed for what would 
> become virtio, but as far as I know there has been no work on such a 
> device.  It certainly makes lots of sense.
> 

There was a virtio-rng device:
http://www.mail-archive.com/virtualization@lists.linux-foundation.org/msg02902.html

Need to search what happened to it in Rusty's queues.
>     J
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization

