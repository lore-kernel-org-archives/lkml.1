Return-Path: <linux-kernel-owner+w=401wt.eu-S932896AbZDAXsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbZDAXsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbZDAXsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:48:08 -0400
Received: from mail.crca.org.au ([67.207.131.56]:33861 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZDAXsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:48:06 -0400
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2009 19:48:06 EDT
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andreas Robinson <andr345@gmail.com>,
       Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <49D3F4A3.1040609@linux.intel.com>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop>
	 <49D3EDEA.4090803@zytor.com>  <49D3F4A3.1040609@linux.intel.com>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Thu, 02 Apr 2009 10:40:02 +1100
Message-Id: <1238629202.9027.111.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2009-04-01 at 16:11 -0700, Arjan van de Ven wrote:
> H. Peter Anvin wrote:
> > Andreas Robinson wrote:
> >> Anyway, I assume it is maintainability rather than size you're concerned
> >> about here?
> > 
> > Right, of course.
> > 
> >> OTOH, the safe version is far from useless.
> >> I estimate (but haven't tested yet) that you would lose about 40 ms in
> >> the Eee test case. That is, the boot-time savings are reduced from 123
> >> to perhaps 85 ms which is still acceptable. It is certainly much less
> >> complicated than the alternatives, so if that's what you would prefer I
> >> can go that way.
> > 
> > I think if the cost is 40 ms once during boot on a slow platform, it's 
> > worth unifying the two codebases.  I am *not* saying that I don't think 
> > boot performance matters -- far be from it -- but I think this is 
> > probably worth the reliability and maintainability advantages of having 
> > a single piece of code if at all possible.
> > 
> > Of course, if you can figure out how to avoid that and still have the 
> > code clean, then that's another matter.
> > 
> > [Cc: Arjan, fast boot evangelizer. ;)]
> 
> as long as LZO is optional.... and it's documented somewhere to not use
> it if you want fast speed I'm totally fine.

Sorry to jump in with a tangential issue, but I just noticed the thread
and it reminded me of an issue :)

Should the lzo code used via cryptoapi (I believe it's the same stuff)
be SMP safe? I've tried to use it work TuxOnIce and get image corruption
(test kernel is 64 bit). The same code works fine if I tell it to use
LZF (which comes with TuxOnIce), no compression or, IIRC, work single
threaded.

Regards,

Nigel

