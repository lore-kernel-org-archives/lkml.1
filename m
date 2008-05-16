Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbYEPHdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbYEPHdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYEPHc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:32:56 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:17123 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYEPHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:32:56 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] virtio: hardware random device
Date: Fri, 16 May 2008 09:31:53 +0200
User-Agent: KMail/1.9.9
Cc: virtualization@lists.linux-foundation.org, Jeff Garzik <jeff@garzik.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       LKML <linux-kernel@vger.kernel.org>, "H. Anvin" <hpa@zytor.com>
References: <482C8595.5030509@garzik.org> <200805160943.08788.rusty@rustcorp.com.au> <200805161531.44725.rusty@rustcorp.com.au>
In-Reply-To: <200805161531.44725.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805160931.53875.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 16. Mai 2008 schrieb Rusty Russell:
> virtio: An entropy device, as suggested by hpa.
> 
> Note that by itself, having a "hardware" random generator does very
> little: you should probably run "rngd" in your guest to feed this into
> the kernel entropy pool.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/char/hw_random/Kconfig      |   10 ++
>  drivers/char/hw_random/Makefile     |    1 
>  drivers/char/hw_random/virtio-rng.c |  143 +++++++++++++++++++++++++++++++
>  include/linux/virtio_rng.h          |    8 ++
>  4 files changed, 162 insertions(+)

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>


