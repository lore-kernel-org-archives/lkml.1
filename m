Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZICTej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZICTej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZICTei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:34:38 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52021 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbZICTeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=R0dUfCLD9H8GzI9y4muxcasv4XiLuC7on0sXk4UvASIAhnv14grvCZnnHvBkm+0+GW
         9frmbYWJYlR1y795tl6vHj0ihnxr8IVOWmjyM1k1y75ZjrgjuH0UulkdyaU2dslKeQym
         yqlvEi2hgOTDyyUWFx9ewSFd5Ks2ooZen6F0M=
MIME-Version: 1.0
In-Reply-To: <4A9FCDC6.3060003@gmail.com>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <4A896324.3040104@trash.net>
	 <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>
	 <4A9EEF07.5070800@gmail.com>
	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>
	 <4A9F1620.2080105@gmail.com>
	 <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>
	 <4A9F7283.1090306@gmail.com>
	 <alpine.DEB.1.10.0909031244230.27903@V090114053VZO-1>
	 <4A9FCDC6.3060003@gmail.com>
Date: Thu, 3 Sep 2009 22:34:38 +0300
X-Google-Sender-Auth: c3729ee017ef01e5
Message-ID: <84144f020909031234y764ebad2t1be8bf28dca25ace@mail.gmail.com>
Subject: Re: [PATCH] slub: fix slab_pad_check()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 5:08 PM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
> Sure, here is the poison thing
>
> [PATCH] slub: fix slab_pad_check()
>
> When SLAB_POISON is used and slab_pad_check() finds an overwrite of the
> slab padding, we call restore_bytes() on the whole slab, not only
> on the padding.
>
> Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks!
