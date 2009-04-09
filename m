Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZDICSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZDICSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 22:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZDICSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 22:18:23 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58848 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752933AbZDICSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 22:18:22 -0400
Date: Thu, 9 Apr 2009 10:18:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-crypto@vger.kernel.org
Subject: Re: [2.6.30-rc1] device-mapper: table: 254:0: crypt: Error
	allocating crypto tfm
Message-ID: <20090409021804.GA1756@gondor.apana.org.au>
References: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8db1092f0904081235x58081f1by842ab45ad861e294@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 09:35:23PM +0200, Maciej Rutecki wrote:
> Kernel 2.6.30.1
> 
> I try mount encrypted partition:
> root@zlom:/home/maciek# cryptsetup create secret /dev/sda6
> Enter passphrase:
> Command failed: device-mapper: reload ioctl failed: Zły argument
> 
> "Zły argument"="Bad argument"

It looks like try_then_request_module has been broken such that it
returns without waiting for the module to complete loading.  I'm
looking into it.

Thakns,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
