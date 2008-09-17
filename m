Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYIQF2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYIQF2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYIQF14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:27:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYIQF1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:27:55 -0400
Message-ID: <48D0954D.4070302@manoweb.com>
Date: Tue, 16 Sep 2008 22:27:41 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Ben Nizette <bn@niasdigital.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver for tightly coupled memory
References: <48CEC71F.3000006@manoweb.com> <20080916093513.GF1916@fluff.org.uk> <48CFEF3F.5040901@manoweb.com> <1221604022.3598.4.camel@moss.renham>            <48D03811.9070805@manoweb.com> <24229.1221619342@turing-police.cc.vt.edu>
In-Reply-To: <24229.1221619342@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19KmrLVmZusIrA3FsbmaWOKt5qwCyk2nXb0x+2
 sJ3juJVbMI074bAUnpikv7QIczp1FNwdzZA44ftSj/ZEu17LOP
 jK3xnA5rQFPFJTmwJslFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> What sort of hardware/software interface does the TCM provide?  You mentioned
> that it could be accessed even while main memory is being accessed - what does
> that look like from the software level?

Well I should ask the details to the hardware engineers but it's like a
separate channel than the one used for main memory. It is not cacheable
either. To the CPU, it just appears to be mapped at some location on the
addressable space. Accessing this TCM will not have any impact on main
memory access, so bursts etc won't be interrupted; other than that, TCM
has double the bandwidth than standard memory - but it's tiny in size,
something like 8 to 32kB as I mentioned earlier.

Hope I was clear enough, feel free to ask me more details if you need

bye
as

