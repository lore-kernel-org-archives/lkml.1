Return-Path: <linux-kernel-owner+w=401wt.eu-S933887AbYBTU37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbYBTU37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYBTU3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:29:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:9029 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbYBTU3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:29:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GpV/TgR/tzvPN+fQ2a6ClfmSsK2Uag76xbqiMXX05OUlvz6Bj8197CM9dvfxHphgW2oQzBdN6Vue5leodm/qfrCsdDcg1qYu5pe8IOj7Lxo1ylHH6lzfrdj6McjTy679WIF6SfEa5AZuyMJoywE7NNTUY1Yt3FU6CNAlJQ0so2s=
Message-ID: <8f53421d0802201229q675b4873l25b61101620c68e6@mail.gmail.com>
Date: Wed, 20 Feb 2008 22:29:41 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Cc: "Milan Broz" <mbroz@redhat.com>, "Alasdair G Kergon" <agk@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
In-Reply-To: <20080220175819.GA28246@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com>
	 <47BC0DA9.1030607@redhat.com>
	 <20080220172449.GD27726@gondor.apana.org.au>
	 <47BC67CE.9070407@redhat.com>
	 <20080220175819.GA28246@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 20, 2008 7:58 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Feb 20, 2008 at 06:47:58PM +0100, Milan Broz wrote:
> >
> > I just tested one affected configuration and problem was in missing
> > "chainiv.ko" module on ramdisk.
>
> Ah OK.  We probably should merge chainiv into the blkcipher
> module too since it's the default IV generator.  I'll take
> care of it.

Right. Manually adding chainiv.ko to initramfs makes it boot again.
