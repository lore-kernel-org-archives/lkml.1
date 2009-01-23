Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbZAWKcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbZAWKcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZAWKbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:31:53 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:45341 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZAWKbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:31:52 -0500
X-Auth-Info: l95FxliFk3gYGZlrLDtpcO3uW37GT6yAlbbMBL19d+g=
Message-ID: <49799C8C.80903@denx.de>
Date: Fri, 23 Jan 2009 11:31:40 +0100
From: Anatolij Gustschin <agust@denx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Matteo Fortini <m.fortini@selcomgroup.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mb862xx: Restrict compliation of platform driver to PPC
References: <496A89A1.8050302@gmail.com>	 <646765f40901191650v5320f5e4tcc5fb7da0555ade1@mail.gmail.com>	 <20090120011945.GA23380@oksana.dev.rtsoft.ru> <646765f40901191800y27530acaw74edc01abdd13e68@mail.gmail.com>
In-Reply-To: <646765f40901191800y27530acaw74edc01abdd13e68@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian Calaby wrote:
> On Tue, Jan 20, 2009 at 12:19, Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
>> Should be Anatolij. ;-)
> 
> Who is the first person on the list, I guess he's missed this or isn't
> reading his email.

I missed this, sorry.

> Before we commit to fixing this properly, is it really worth it? Is
> this hardware ever likely to be used with SPARC?

I don't think it will ever be used with SPARC, so your patch is Ok.

> Given that there are PCI and OF versions of the driver, it seems to me
> that this is available as a PCI expansion card, and as a graphics chip
> built into some PPC motherboards. The initial commit says: "Lime GDC
> support is known to work on PPC440EPx based lwmon5 and MPC8544E based
> socrates embedded boards, both equipped with Lime GDC." so I'm
> guessing that this graphics chip is designed for embedded boards. I
> can find references to it's use in embedded automotive applications on
> Google but I can't find any reference to the Fujitsu LIME (MB86276)
> and SPARC on Google.

If LIME chip should ever be used with SPARC, support for this
could be added later. LIME doesn't have PCI interface, it is
connected to the host cpu bus. PCI version of the driver is for
CoralP and Carmine chips which have PCI interface.

Anatolij

