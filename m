Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbZDCBMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbZDCBMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbZDCBLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:11:47 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:52247 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751238AbZDCBLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:11:46 -0400
Date: Fri, 3 Apr 2009 09:11:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: avi@redhat.com, ghaskins@novell.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090403011125.GA6557@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D5018E.4040801@codemonkey.ws>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori <anthony@codemonkey.ws> wrote:
>
> Anyway, if we're able to send this many packets, I suspect we'll be able 
> to also handle much higher throughputs without TX mitigation so that's 
> what I'm going to look at now.

Awesome! I'm prepared to eat my words :)

On the subject of TX mitigation, can we please set a standard
on how we measure it? For instance, do we bind the the backend
qemu to the same CPU as the guest, or do we bind it to a different
CPU that shares cache? They're two completely different scenarios
and I think we should be explicit about which one we're measuring.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
