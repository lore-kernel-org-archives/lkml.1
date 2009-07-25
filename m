Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZGYFWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZGYFWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 01:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZGYFWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 01:22:46 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46073 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZGYFWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 01:22:46 -0400
Message-ID: <4A6A96AB.7030609@billgatliff.com>
Date: Sat, 25 Jul 2009 00:22:51 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Peter Zijlstra <peterz@infradead.org>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
References: <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>	<1248441290.6987.52.camel@twins>	<454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>	<1248442415.6987.56.camel@twins>	<454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>	<1248443656.6987.61.camel@twins>	<454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com>	<1248446910.6987.111.camel@twins>	<20090724154036.GG27755@shareable.org>	<1248451279.6987.138.camel@twins> <20090724233057.GO27755@shareable.org>
In-Reply-To: <20090724233057.GO27755@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> For simple things like "try to keep the buffer to my DVD writer full"
> (no I don't know how much CPU that requires - it's a kind of "best
> effort but try very hard!"), it would be quite useful to have
> something like RT-bandwidth which grants a certain percentage of time
> as an RT task, and effectively downgrades it to SCHED_OTHER when that
> time is exceeded to permit some fairness with the rest of the system.
>   

Useful perhaps, but an application design that explicitly communicates 
your desires to the scheduler will be more robust, even if it does seem 
more complex at the outset.

I'm with Peter on this one.  My impression of RT-bandwidth is that you 
shouldn't ever see it doing anything unless your system contains an 
error.  In those situations, it's definitely a handy alternative to 
rebooting to get your shell back.  But I don't think you want to build a 
system that depends on it, perhaps for no other reason than the fact 
that if RT-bandwidth doesn't make your system behave itself then you 
don't have a Plan B anymore.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

