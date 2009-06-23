Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbZFWJXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbZFWJXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZFWJXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:23:34 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45672 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZFWJXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D7eRCcfmXWJBRRnswzinvW7xXol1SvGWezH77hHQQ+w5J/yjaQXbTvx28mVkh8RmBl
         6BT7HFCL3k5F4vaFMbTAQKlh2+aUKM6FOP2fZd367+kNf8FWwx5MbkwQ3/mx4EZ+kqe/
         Am3xqJcTxgE2axTjt/7a81em5hytemW4Rpf5A=
MIME-Version: 1.0
In-Reply-To: <20090622164604.GG29188@n2100.arm.linux.org.uk>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
	 <20090619134446.GI24573@n2100.arm.linux.org.uk>
	 <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
	 <20090622154308.GC29188@n2100.arm.linux.org.uk>
	 <1245685846.15580.107.camel@pc1117.cambridge.arm.com>
	 <20090622155659.GE29188@n2100.arm.linux.org.uk>
	 <1245687196.15580.122.camel@pc1117.cambridge.arm.com>
	 <20090622164604.GG29188@n2100.arm.linux.org.uk>
Date: Tue, 23 Jun 2009 11:23:35 +0200
Message-ID: <63386a3d0906230223v66564c5bh613d05a0defb8c35@mail.gmail.com>
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pierre Ossman <pierre@ossman.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Russell King - ARM Linux <linux@arm.linux.org.uk>:

> If I knew what this "eMMC" was...

It's to be read out "embedded MultiMediaCard", comes
from JEDEC but is based on the standard from MMCA.
Just as it says, it's like an MMC card you embed.

It uses lower voltages than MMC and thus save  some
power. It doesn't look like an MMC card either, it comes
in a standardized solder-on BGA package so it looks
like any chip, no expensive card holders. It uses 8bit wide
transfers giving a total of 10 pins for the bus.
(Plus voltage of course.)

But usually you reuse a standard MMC hardware IP
to talk to it.

Here is some whitepaper:
http://www.jedec.org/download/search/JESD84-C43.pdf

Linus Walleij
