Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbXJPJbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbXJPJbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXJPJbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:31:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38219 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbXJPJbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:31:24 -0400
Date: Tue, 16 Oct 2007 11:31:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: Killing a network connection
Message-ID: <20071016093121.GA28393@one.firstfloor.org>
References: <9eFcS-It-3@gated-at.bofh.it> <9eGsi-2Sr-35@gated-at.bofh.it> <E1IhZi3-0001Hd-Ug@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IhZi3-0001Hd-Ug@be1.lrz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 01:50:55AM +0200, Bodo Eggert wrote:
> Andi Kleen <andi@firstfloor.org> wrote:
> > Stefan Monnier <monnier@iro.umontreal.ca> writes:
> 
> >> The main use for me is to deal with dangling connections due to taking
> >> network interfaces up&down with different IP addresses (typically the wlan0
> >> interface where the IP is different because I've modes from an AP to
> >> another).  Of course, maybe there's another way to solve this particular
> >> problem, in case I'd like to hear about it as well.
> > 
> > Long ago I did a 2.4 patch that solved exactly this problem. It introduced
> > a new ifconfig flag "dynamic" and when a dynamic address went down
> > all TCP connections originating from it were killed. It's still available
> > in older SUSE releases. I might post a forward port later.
> 
> There is a /proc/sys/net/ipv4/ip_dynaddr sysctl in 2.6.21.

That only handles SYN_SENT and does something different (it rewrites
the source address)

-Andi
