Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYCZC2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYCZC2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYCZC2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:28:06 -0400
Received: from gw.goop.org ([64.81.55.164]:37429 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbYCZC2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:28:05 -0400
Message-ID: <47E9B398.3080008@goop.org>
Date: Tue, 25 Mar 2008 19:23:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jack Steiner <steiner@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org> <20080325175657.GA6262@sgi.com> <20080325180616.GX2170@one.firstfloor.org>
In-Reply-To: <20080325180616.GX2170@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> No instead of having lots of if (xyz_system) do_xyz_special()
> go through smp_ops for the whole thing so that UV would just have a 
> special smp_ops that has special implementions or wrappers. 
>
> Oops I see smp_ops are currently only implemented
> for 32bit. Ok do it only once smp_ops exist on 64bit too. 
>   

I think glommer has patches to unify smp stuff, which should include 
smp_ops.

    J
