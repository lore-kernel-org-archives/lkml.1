Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZBXIBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZBXIBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 03:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBXIBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 03:01:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:33825 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZBXIBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 03:01:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YfOIMbhLMf5DdRXdc41dyEeLZyI/XwzTujFp2IpkMsnq467A9c1JWFV8GLYrSd1j/g
         F6ybGWwyWkCX7a8dlSZLO5lOFoKkMbhYNHtquzmP1ugSyJ3fkjIfN1W0uKK1SZWtuAos
         9/QfTPHQlhbnJsGCqPL4HSrQ2QAGAF8iO5kWo=
MIME-Version: 1.0
In-Reply-To: <20090223.224652.121864647.davem@davemloft.net>
References: <Pine.LNX.4.64.0902212042420.20526@wrl-59.cs.helsinki.fi>
	 <20090221.235308.172360407.davem@davemloft.net>
	 <b6a2187b0902232240m6f2347efs84639bb59a19269e@mail.gmail.com>
	 <20090223.224652.121864647.davem@davemloft.net>
Date: Tue, 24 Feb 2009 16:01:39 +0800
Message-ID: <b6a2187b0902240001s52d3e987pf1238816f9b59af7@mail.gmail.com>
Subject: Re: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ilpo.jarvinen@helsinki.fi, herbert@gondor.apana.org.au, rjw@sisk.pl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 2:46 PM, David Miller <davem@davemloft.net> wrote:
> Actually, it isn't.
>
> Herbert's change is in net-next-2.6 which will show up in linux-next
> rather than Linus's 2.6.29-rcX tree.
>

Uh, I got it wrong. Didn't look into details. Just noticed that
tcp_output.c was changed today, so I just assume that was the one ...
which turned out to a one-liner comment removed.

Anyway, I just tested the Herbert's patch and it looks good. rlogin not hanging.

Sorry for the earlier fault report.

Thanks
Jeff.
