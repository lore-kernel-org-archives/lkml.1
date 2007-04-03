Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXDCUYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXDCUYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422673AbXDCUYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:24:35 -0400
Received: from gw.goop.org ([64.81.55.164]:60257 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422695AbXDCUYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:24:34 -0400
Message-ID: <4612B7EF.4080100@goop.org>
Date: Tue, 03 Apr 2007 13:24:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <p73abxpz5u1.fsf@bingen.suse.de> <46128C1B.1090900@redhat.com> <20070403182241.4b9abab6@the-village.bc.nu> <20070403173010.GC23689@one.firstfloor.org>
In-Reply-To: <20070403173010.GC23689@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Migration is fundamentally incompatible with many CPU optimizations.
> But that's not a reason to not optimize anymore.
>   

I've been thinking about ways in which Xen could provide the current
vcpu->cpu map to guest domains.  Obviously this would change over time,
but it could remain current enough to be useful.

> But I guess luckily most migration users will be able to live
> with a little decreased performance after it.
>   

At least in the Xen case, the source and target machines need to be
fairly similar in architecture (can't deal with vastly different CPU
types, for example).

    J
