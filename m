Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbZEJSBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbZEJSBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 14:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbZEJSBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 14:01:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbZEJSBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 14:01:42 -0400
Message-ID: <4A071518.8000307@zytor.com>
Date: Sun, 10 May 2009 10:55:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
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
Subject: Re: [Xen-devel] Re: [PATCH 06/16] xen: disable PAT
References: <4A05CD29.6050505@zytor.com>	<C62C5B3C.AB1A%keir.fraser@eu.citrix.com> <20090510142928.66bb57bb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090510142928.66bb57bb@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
> There are quite a few different CPUs with PAT errata. I've no idea why
> there are so many errata about that specific bit.
> 

I suspect it is simply because:

a) it moves around between the various page table formats;
b) the default configuration and existing OSes don't use it;
c) it isn't even *present* in some formats.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

