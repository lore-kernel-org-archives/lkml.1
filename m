Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYJaVEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYJaVEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYJaVEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:04:13 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:55893 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYJaVEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:04:12 -0400
Message-ID: <490B7284.2010003@cosmosbay.com>
Date: Fri, 31 Oct 2008 22:03:00 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, ilpo.jarvinen@helsinki.fi,
       rjw@sisk.pl, mingo@elte.hu, s0mbre@tservice.net.ru,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
References: <Pine.LNX.4.64.0810302047030.22084@wrl-59.cs.helsinki.fi> <20081031.005219.141937694.davem@davemloft.net> <Pine.LNX.4.64.0810311119510.7072@wrl-59.cs.helsinki.fi> <20081031.025159.51432990.davem@davemloft.net> <490AE1CD.9040207@cosmosbay.com> <20081031125713.6c6923de@extreme> <20081031201016.GA4748@ioremap.net>
In-Reply-To: <20081031201016.GA4748@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 31 Oct 2008 22:03:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov a écrit :
> On Fri, Oct 31, 2008 at 12:57:13PM -0700, Stephen Hemminger (shemminger@vyatta.com) wrote:
>> Why bother with last_rx at all on loopback.  I have been thinking
>> we should figure out a way to get rid of last_rx all together. It only
>> seems to be used by bonding, and the bonding driver could do the calculation
>> in its receive handling.
> 
> Not related to the regression: bug will be just papered out by this
> changes. Having bonding on loopback is somewhat strange idea, but still
> this kind of changes is an attempt to make a good play in the bad game:
> this loopback-only optimization does not fix the problem.
> 

Just to be clear, this change was not meant to be committed.
It already was rejected by David some years ago (2005, and 2006)

http://www.mail-archive.com/netdev@vger.kernel.org/msg07382.html

If you read my mail, I was *only* saying that tbench results can be sensible to
cache line ping pongs. tbench is a crazy benchmark, and only is a crazy benchmark.

Optimizing linux for tbench sake would be .... crazy ?

