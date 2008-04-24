Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYDXARR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYDXARR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYDXARF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:17:05 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:54647 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbYDXARE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:17:04 -0400
Date: Thu, 24 Apr 2008 01:16:56 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
Message-ID: <20080424001656.GM4825@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Michael Kerrisk <mtk.manpages@googlemail.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	mtk.manpages@gmail.com
References: <20080308022321.GC5853@implementation> <20080323.215641.192753003.davem@davemloft.net> <20080324104330.GF4434@implementation.uk.xensource.com> <87abko734d.fsf@basil.nowhere.org> <20080324121719.GJ4434@implementation.uk.xensource.com> <20080324122700.GK4434@implementation.uk.xensource.com> <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com> <4808D1C5.8050304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4808D1C5.8050304@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk, le Fri 18 Apr 2008 18:52:21 +0200, a écrit :
> >>  +is
> >>  +.IR sizeof(sa_family_t) ,
> 
> Why did you write sa_family_t here?

Because to me it made more sense.

> Dave M already said sizeof(short), which is the same thing,

Ok, but that's exposing implementation.


> and I see that in net/unix/af_unix.c::unix_getname() there is:
> 
>                 *uaddr_len = sizeof(short);

I'd say that code should be fixed into using sa_family_t.

Samuel
