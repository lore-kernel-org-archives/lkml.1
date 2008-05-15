Return-Path: <linux-kernel-owner+w=401wt.eu-S1765029AbYEOT4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765029AbYEOT4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYEOTxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:53:34 -0400
Received: from gw.goop.org ([64.81.55.164]:49363 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764117AbYEOTxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:53:33 -0400
Message-ID: <482C94AF.2010202@goop.org>
Date: Thu, 15 May 2008 20:53:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Virt RNG?
References: <482C8595.5030509@garzik.org>
In-Reply-To: <482C8595.5030509@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Has anyone yet written a "hw" RNG module for virt, that reads the host's 
> random number pool?
>
> All this talk[1] about IRQF_SAMPLE_RANDOM in network drivers reminds me 
> that virt guest instances should be grabbing random numbers from the 
> host, especially if the host has a hardware RNG.

It was actually one of the first device types proposed for what would 
become virtio, but as far as I know there has been no work on such a 
device.  It certainly makes lots of sense.

    J
