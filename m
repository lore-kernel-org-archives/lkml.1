Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbXCSUzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbXCSUzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXCSUzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:55:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55479 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbXCSUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:55:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Avi Kivity <avi@argo.co.il>
Cc: Bill Irwin <bill.irwin@oracle.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
References: <45E5913D.3080505@redhat.com>
	<20070228204144.GA32316@one.firstfloor.org>
	<20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com>
	<Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com>
	<20070306203432.GD18774@holomorphy.com>
	<1173241715.3236.16.camel@laptopd505.fenrus.org>
	<20070307064423.GH18774@holomorphy.com>
	<1173270892.3176.4.camel@laptopd505.fenrus.org>
	<20070307144816.GQ18774@holomorphy.com> <45EFBEB3.20708@argo.co.il>
Date: Mon, 19 Mar 2007 14:53:22 -0600
In-Reply-To: <45EFBEB3.20708@argo.co.il> (Avi Kivity's message of "Thu, 08 Mar
	2007 09:43:47 +0200")
Message-ID: <m1k5xdvttp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@argo.co.il> writes:

> I don't understand why interrupt latency suffers.  Sure, the interrupt that's
> being masked is delayed, but on the other hand the interrupt that's doing the
> masking is not.  We're moving the latency from the first interrupt to the
> second, probably with a slight gain in overall throughput.
>
> It *does* matter if the interrupts have meaningful priorities.  Is that the case
> here?

No.

I'll queue this in my irq things to think about...

Eric
