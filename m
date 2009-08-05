Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbZHECIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbZHECIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbZHECIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:08:22 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:56963 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180AbZHECIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ln3sRZfRwmC1nk/t3roNSCPlYa5cHH1SFrgDO6947KuoY1zndZ67hc/hnDcoKjUrpL
         +uJihGXHTj6QJqZKi37qnihsI8cFkbT+1fQzBZpPsnszNSzesipE5P/1aBe5FzIWVi/S
         ThpK0QiLOD1BFxttFF6EFz7JWNjrw8g3ZkUyQ=
MIME-Version: 1.0
In-Reply-To: <4A787C2C.5070000@mnementh.co.uk>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>
	 <4A7053E8.8050303@mnementh.co.uk>
	 <20090729201702.GA28202@linux-sh.org>
	 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
	 <4A716F1C.2050805@mnementh.co.uk>
	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>
	 <4A71F2A5.4060206@mnementh.co.uk>
	 <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
	 <4A787C2C.5070000@mnementh.co.uk>
Date: Wed, 5 Aug 2009 11:08:21 +0900
Message-ID: <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
Subject: Re: MMC: Make the configuration memory resource optional
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Wed, Aug 5, 2009 at 3:21 AM, Ian Molton<ian@mnementh.co.uk> wrote:
> I still do not have info from people about wether non MFD users of the
> tmio-mmc driver have a 1:1 host/card clock capability.
>
> I could really use the information if anyone expects me to sort this
> situation out.

Sorry for not answering your question earlier. This may sound starnge,
but I don't have any datasheet. I do however think that you can assume
a 1:1 host/card clock capability, at least to begin with.

So please use the clock framework to enable/disable the clock and get
the rate, and we'll do our best to adjust the architecture code after
that. And I'll cook up a patch for Runtime PM on top of that if that's
ok with you.

Thanks.

/ magnus
