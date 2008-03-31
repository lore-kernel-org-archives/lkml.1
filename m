Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYCaMsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYCaMsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYCaMsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:48:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52166 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYCaMsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:48:32 -0400
Date: Mon, 31 Mar 2008 14:52:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Jack Steiner <steiner@sgi.com>,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080331125213.GF29105@one.firstfloor.org>
References: <87abknhzhd.fsf@basil.nowhere.org> <20080325175657.GA6262@sgi.com> <20080326073823.GD3442@elte.hu> <86802c440803301323q5c4bd4f4k1f9bdc1d6b1a0a7b@mail.gmail.com> <20080330210356.GA13383@sgi.com> <20080330211848.GA29105@one.firstfloor.org> <86802c440803301629g6d1b896o27e12ef3c84ded2c@mail.gmail.com> <20080331021821.GC20619@sgi.com> <86802c440803301920o47335876yac12a5a09d1a8cc9@mail.gmail.com> <20080331123338.GA14636@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331123338.GA14636@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - mach-voyager: obsolete.

You just have to convince James @)

> 
>  - mach-es7000: on the way out - latest ES7000's are generic.

That would mean dropping support for prev-gen es7000 which are not that
old actually (only a few years). But I think with a little effort the 
old es7000 code could be fit into the generic architecture. It is not
that far away from a normal PC.

> 
>  - mach-rdc321x: it's being de-sub-architectured. It's about one patch 
>                  away from becoming a non-subarch.

mach-numaq (not in arch, but spread out all over the port) 
	I hear there are only a one or two machines running left.
	Unfortunately they are in test.kernel.org, but hopefully
	they will die soon.
	NUMAQ has quite a lot of ugly ifdefs and special cases that would be 
	great to eliminate

mach-bigsmp/mach-summit (also in asm only)
	obsolete, should be deprecated for mach-generic
	(just generic currently pulls in code from them)
	A good first step would be to just disable the separate CONFIG
	options and only allow using them through generic.

-Andi

