Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYIPWu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYIPWu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYIPWuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:50:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYIPWuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:50:19 -0400
Message-ID: <48D03811.9070805@manoweb.com>
Date: Tue, 16 Sep 2008 15:49:53 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>
CC: Ben Dooks <ben-linux@fluff.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver for tightly coupled memory
References: <48CEC71F.3000006@manoweb.com>	 <20080916093513.GF1916@fluff.org.uk>  <48CFEF3F.5040901@manoweb.com> <1221604022.3598.4.camel@moss.renham>
In-Reply-To: <1221604022.3598.4.camel@moss.renham>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18R4y2bqd9PqRPDJZPeo86Xkcy/CkhxAw1n6fB
 Mcf2P/dUPDsTuWDQpleSAbDtKBfQU4drQbcydtcc3F6Z+2u1sx
 TRmCJUi4FYSi3wEUuMV4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:

> If a driver needs a quick FIFO it can attempt to get the RAM for said
> FIFO from the genalloc and fall back to main memory otherwise.  Simple,
> flexible, easy :-)

Well, interesting, that is why I asked here before writing code.

In this case however, do you imply that a device driver will just do all
the genalloc stuff? In this case it has to know about the TCM details,
and problems may arise if more than one driver wants to use this
feature. Or, are you suggesting to write a small TCM driver that will do
the gen_pool_create() and gen_pool_add() and then export the struct
gen_pool for use by other drivers that may require it?

I mentioned implementing a FIFO because I already have a couple of
examples where this FIFO thing would be used.

Bye bye, thank you
Alessio


