Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbZKLAnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbZKLAnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbZKLAno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:43:44 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:35570 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754172AbZKLAnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:43:43 -0500
Date: Thu, 12 Nov 2009 08:43:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/7] crypto: testmgr: fix warning
Message-ID: <20091112004332.GA777@gondor.apana.org.au>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com> <alpine.LSU.2.00.0910191551030.8582@wotan.suse.de> <4ADC707E.2040802@redhat.com> <4ADC71C4.3020805@redhat.com> <94a0d4530911111632w4767b704v887629dcf0f2b0e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94a0d4530911111632w4767b704v887629dcf0f2b0e1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 02:32:10AM +0200, Felipe Contreras wrote:
> On Mon, Oct 19, 2009 at 4:03 PM, Jarod Wilson <jarod@redhat.com> wrote:
> > So yeah, I rescind my claim that initializing err to 0 is incorrect, I think
> > that's just fine.
> 
> So is this acked? Who will merge it?

It's already in cryptodev-2.6:

commit fa4ef8a6af4745bbf3a25789bc7d4f14a3a6d803
Author: Felipe Contreras <felipe.contreras@gmail.com>
Date:   Tue Oct 27 19:04:42 2009 +0800

    crypto: testmgr - Fix warning

    crypto/testmgr.c: In function ‘test_cprng’:
    crypto/testmgr.c:1204: warning: ‘err’ may be used uninitialized in this function

    Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
