Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYCaCSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYCaCSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbYCaCSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:18:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60672 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbYCaCSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:18:24 -0400
Date: Sun, 30 Mar 2008 21:18:21 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080331021821.GC20619@sgi.com>
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org> <20080325175657.GA6262@sgi.com> <20080326073823.GD3442@elte.hu> <86802c440803301323q5c4bd4f4k1f9bdc1d6b1a0a7b@mail.gmail.com> <20080330210356.GA13383@sgi.com> <20080330211848.GA29105@one.firstfloor.org> <86802c440803301629g6d1b896o27e12ef3c84ded2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803301629g6d1b896o27e12ef3c84ded2c@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> if the calling path like GET_APIC_ID is keeping checking if it is UV
> box after boot time, that may not good.
> 
> don't need make other hundreds of machine keep running the code only
> for several big box all the time.
> 
> YH


I added trace code to see how often GET_APIC_ID() is called. For
my 8p AMD box, the  function is called 6 times per cpu during boot.
I have not seen any other calls to the function after early boot
although I'm they occur under some circumstances.

Can you think of a workload where the frequency of calls is
high enough to be significant??

--- jack
