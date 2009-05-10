Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZEJRe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZEJRe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 13:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZEJReR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 13:34:17 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:11082 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZEJReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 13:34:16 -0400
X-IronPort-AV: E=Sophos;i="4.40,324,1238976000"; 
   d="scan'208";a="5190562"
User-Agent: Microsoft-Entourage/12.17.0.090302
Date: Sun, 10 May 2009 18:34:11 +0100
Subject: Re: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Linux@zytor.com" <Linux@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Message-ID: <C62CCEA3.AB56%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
Thread-Index: AcnRc0G7JonX0J8QSYWYAHtcYY5xigAIkW/w
In-Reply-To: <20090510142928.66bb57bb@lxorguk.ukuu.org.uk>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 10 May 2009 17:34:16.0542 (UTC) FILETIME=[8AC74FE0:01C9D195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2009 14:29, "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:

>> have matching PAT configuration. No elfnote would mean use Xen's existing
>> PAT setup (or if that's very dangerous then disable PAT altogether, perhaps
>> dependent on CPU model/stepping?).
> 
> Hiding it on errata hit processors if the guest cannot support PAT
> safely on such processors sounds a good policy and its one being a
> hypervisor you can do neatly.
> 
> There are quite a few different CPUs with PAT errata. I've no idea why
> there are so many errata about that specific bit.

Okay, this sounds like a good way to then. I can work out details with
Jeremy from here, and this will then have no impact on Linux PAT logic. If
we advertise PAT to Linux via CPUID, that will mean PAT is set up just as
Linux requires.

 Thanks,
 Keir


