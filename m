Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbYEOUc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbYEOUc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYEOUcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:32:21 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:31883 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYEOUcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:32:20 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Virt RNG?
Date: Thu, 15 May 2008 22:31:56 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>, jeremy@xensource.com,
       Herbert Xu <herbert@gondor.apana.org.au>, Avi Kivity <avi@qumranet.com>
References: <482C8595.5030509@garzik.org>
In-Reply-To: <482C8595.5030509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805152231.56967.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 15. Mai 2008 schrieb Jeff Garzik:
> Has anyone yet written a "hw" RNG module for virt, that reads the host's 
> random number pool?
> 
> All this talk[1] about IRQF_SAMPLE_RANDOM in network drivers reminds me 
> that virt guest instances should be grabbing random numbers from the 
> host, especially if the host has a hardware RNG.

Yes, there was a drivers/char/hw_random/virtio-rng.c in Rusty's lguest 
repository. 
http://www.mail-archive.com/virtualization%40lists.linux-foundation.org/msg02902.html

I have tested this driver with this fix
https://lists.linux-foundation.org/pipermail/virtualization/2008-January/009737.html
and it worked.
As it transfers only 4 byte per hypercall it is not mindblowingly fast, but I 
guess it is fast enough.

Dont know why it never hit mainline.

Christian

