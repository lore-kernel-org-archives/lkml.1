Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbXLFXGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbXLFXGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXLFXGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:06:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40246 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXLFXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:06:13 -0500
Date: Fri, 7 Dec 2007 00:06:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Renzo Davoli <renzo@cs.unibo.it>,
       linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071206230611.GK20595@one.firstfloor.org>
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206212644.GA26725@one.firstfloor.org> <47586E7F.1020903@nortel.com> <20071206220754.GF20595@one.firstfloor.org> <47587F90.8010400@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47587F90.8010400@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 05:02:40PM -0600, Chris Friesen wrote:
> Andi Kleen wrote:
> 
> >>On a 1.4GHz P4 I measured a 44% increase in latency between a unix 
> >>datagram and a UDP datagram.
> 
> >That's weird.
> 
> I just reran on a 3.2GHZ P4 running 2.6.11 (Fedora Core 4).  42% latency 
> increase.

Sounds like something that should be looked into. I know of no
principal reasons for that.

> For stream sockets, unix gives approximately a 62% bandwidth increase 
> over tcp.   (Although tcp could probably be tuned to do better than this.)

How long a stream did you test? You might be measuring slow start.

-Andi
