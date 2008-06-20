Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYFTS75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYFTS75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYFTS7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:59:42 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:11862 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYFTS7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=wJtG9zj/nfYyngPixn5i6iMS0swp7FBs/IbCXdPT5lUvBydhJJ7Mavr/NVJAZRXNxq
         TZDb7yR4V7GkH77MDI/vr53WOm/cumdBRGDZ9chx2ObkEaLAYqFJakEfZ/5j0bnSmQxF
         cz3RFlXiVByVjyQ1RTNRB2lHn3hZgUg9gc5dM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Grant Grundler" <grundler@google.com>
Subject: Re: [git patches] IDE fixes
Date: Fri, 20 Jun 2008 21:00:52 +0200
User-Agent: KMail/1.9.9
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200806202007.38081.bzolnier@gmail.com> <20080620190948.537f7f7a@lxorguk.ukuu.org.uk> <da824cf30806201135y7235df5cocd1dfe30d9cae54a@mail.gmail.com>
In-Reply-To: <da824cf30806201135y7235df5cocd1dfe30d9cae54a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806202100.52560.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2008, Grant Grundler wrote:
> On Fri, Jun 20, 2008 at 11:09 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> >> +     PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF45", 0x709b1bf1, 0xf68b632),
> >
> > That one seems to be a digit short - is it 0x0f68b632 or a typo ?
> 
> Typo. Original patch seems to have 0xf68b6f32
> 
> http://lists.infradead.org/pipermail/linux-pcmcia/2008-May/005496.html

Thanks guys! [ ide-cs's ID lacked 'f' while pata_pcmcia one had it ]

I fixed the corresponding commit and recreated the git tree for Linus.

Bart
