Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYAICdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYAICdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYAICcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:32:53 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:5426 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYAICcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U7mM1GwgjVJVNxzguEsSYyOqzEYrNIbj+iar2acGeML3H6UY7NDUzVgvRAgtk3uGRRPAfOkFlIbRVce2/3XEX/ok+bgs8CmpnXZZFwNQbnBJrNcft1OqYLSydkvSbdVfUU1dehAdgMuzFhlIxlfBOJw1/o3zql3p+AE4DbScNYI=
Message-ID: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
Date: Wed, 9 Jan 2008 10:32:48 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>, cliff.cai@analog.com
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080108214946.03018d95@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801081329.39611.vapier.adi@gmail.com>
	 <20080108202157.0b8d3393@poseidon.drzeus.cx>
	 <200801081440.49683.vapier.adi@gmail.com>
	 <20080108214946.03018d95@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 4:49 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Tue, 8 Jan 2008 14:40:49 -0500
> Mike Frysinger <vapier.adi@gmail.com> wrote:
>
> >
> > i dont understand what's confusing.  the Blackfin on chip host controller only
> > supports 1-bit MMC, but it supports 4-bit SD/SDIO.  this is a fact.  while it
> > may be a stupid decision, it is what it is, and i need the framework made
> > more flexible in order to get the Blackfin driver merged cleanly.  we do
> > software for hardware, we dont do hardware.
>
> Well, since I've seen no _hardware_ differences between 4-bit MMC and 4-bit SD, "support" in this case must me "vendor will guarantee it works". And that is not the kind of "support" that needs a distinction in the code.
>
> So, again, if you feel that there is a hardware difference between 4-bit MMC and 4-bit SD then please elaborate as it is my understanding that they are identical.
>

As Mike said, the reason split this flag is because Blackfin on-chip
SDIO controller's limitation.
Cliff is working on it for a long time, so I dropped him in. Hope he
can clarify the confusing things.

Thanks
-Bryan Wu
