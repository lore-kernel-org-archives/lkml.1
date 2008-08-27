Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYH0BI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYH0BI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 21:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYH0BIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 21:08:16 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:31438 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYH0BIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 21:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IDDWW3k/RreLpmGdz+50ES8kjeVkDF9udYxjceuP2wALsUVsKKbk/8T4gbhzf8lf4C
         sfuMS3m3ug1Za7m7EKVaag8M2GwDFX+B/rZnFKlRtvzEZ7IugZxRO7wi9FIkphOkbfHd
         Tg6E+lLaiD282hNxI+DahnRbDVI8VIi77bc6I=
Message-ID: <f7848160808261808p3391c99ekfa1d8991bbf73c10@mail.gmail.com>
Date: Tue, 26 Aug 2008 21:08:13 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
In-Reply-To: <48B4A577.3020303@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <200808261111.19205.rusty@rustcorp.com.au>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
	 <48B4A577.3020303@snapgear.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 8:53 PM, Greg Ungerer <gerg@snapgear.com> wrote:

> I have some simple devices (network access/routers) with 8MB of RAM,
> at power up not really being configured to do anything running 25
> processes. (Heck there is over 10 kernel processes running!). Configure
> some interfaces and services and that will easily push past 40.
> I'd be happy with a 160k saving :-)
>

So you really need to run all 25 processes on that 8Mb box?
(For reference even the NGW100 development board comes with 16Mb RAM).

Even if you do need those all 25 processes on the 8Mb box, fixing the
memory usage of those user space hogs is lot better than trying to
save 160Kb in kernel stacks.
Last I looked, user space wasn't particularly frugal with memory usage.

Parag
