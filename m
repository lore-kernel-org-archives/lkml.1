Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYLDWwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYLDWwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbYLDWwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:52:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:40305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbYLDWwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:52:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LIuVq0kQjo1p+DVceSbuzPUcRXyv1TF0aSQRdJQeMymCZrSOdkhaOaYGbBzmHUKKLr
         uxR2bYHv6wgRx50aOM9+rpbDGj/2NdwOfMu4ih5QTr2LCYg/rRjqQwG/oELvv07axHs6
         P1V37HeRynOh1fsgKweTJHNWztjDVb2mNp+2M=
Message-ID: <49385DB7.4060306@gmail.com>
Date: Thu, 04 Dec 2008 23:46:15 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
References: <1228394671.3732.77.camel@blaa>
In-Reply-To: <1228394671.3732.77.camel@blaa>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2008 01:44 PM, Mark McLoughlin wrote:
> Nothing takes a ref on virtio_pci, so even if you have
> devices in use, rmmod will attempt to unload the module.

It unbinds the device properly as any other driver. So what's the problem here?

> Fix by simply making each device take a ref on the module.
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>
> Reported-by: Michael Tokarev <mjt@tls.msk.ru>
> ---
>  drivers/virtio/virtio_pci.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
