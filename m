Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYH0QI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYH0QI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbYH0QHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:07:53 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30684 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152AbYH0QHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:07:52 -0400
Message-ID: <48B57BD3.5050206@hp.com>
Date: Wed, 27 Aug 2008 09:07:47 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Eric Dumazet <dada1@cosmosbay.com>,
       Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <200808220457.40892.denys@visp.net.lb>	<20080826201406.GA24827@2ka.mipt.ru> <48B46B48.7030609@cosmosbay.com>	<20080826205158.GA15266@2ka.mipt.ru> <87vdxmr53f.fsf@basil.nowhere.org>
In-Reply-To: <87vdxmr53f.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Evgeniy Polyakov <johnpol@2ka.mipt.ru> writes:
> 
>>Yup, this innocent toys can end up with this such behaviour on modern
>>highly loaded machines.
> 
> 
> I and also other people had some patches to move the time stamp
> measuring into the socket. This way the time stamping didn't need to
> be enabled on all packets, only on those that actually end up at a
> socket that requires the time stamp.
> 
> Unfortunately DaveM didn't like it because some bank wanted
> different semantics, see the discussion in 
> http://thread.gmane.org/gmane.linux.network/91679
> 
> Perhaps you can find out which bank it was and send them a bill for
> your CPU time ;-)

Those banks really want to crank down on latency - to the point they 
start disabling interrupt coalescing.  I bet they'd toss anything out 
they could to shave another microsecond.

rick jones
