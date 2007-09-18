Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbXIRW35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbXIRW35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbXIRW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:29:50 -0400
Received: from gw.goop.org ([64.81.55.164]:46779 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbXIRW3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:29:49 -0400
Message-ID: <46F0515E.2010608@goop.org>
Date: Tue, 18 Sep 2007 15:29:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca>	<20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <p73myvjwri3.fsf@bingen.suse.de>
In-Reply-To: <p73myvjwri3.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>   
>> It's a pity that gas seems to generate plain 0x90 nops rather than
>> long-nop forms here.  I thought it could do that.
>>     
>
> .p2align does it

Just .p2align?  Not align, balign, org or skip?  Seems... strange.

    J
