Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbZBMXCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbZBMXCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZBMXCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 18:02:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbZBMXCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 18:02:47 -0500
Message-ID: <4995FB44.5070702@zytor.com>
Date: Fri, 13 Feb 2009 14:59:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <49939964.4070607@kernel.org> <49939B08.1050801@kernel.org> <200902140728.55954.rusty@rustcorp.com.au>
In-Reply-To: <200902140728.55954.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 12 February 2009 14:14:08 Tejun Heo wrote:
>> Oops, those are the same ones.  I'll give a shot at cooking up
>> something which can be dynamically sized before going forward with
>> this one.
> 
> That's why I handed it to you! :)
> 
> Just remember we waited over 5 years for this to happen: the point of these
> is that Christoph showed it's still useful.
> 
> (And I really like the idea of allocing congruent areas rather than remapping
>  if someone can show that it's semi-reliable.  Good luck!)

Well, it's easy to do in virtual space.  Trying to do it in physical 
space seems nearly impossible.

	-hpa
