Return-Path: <linux-kernel-owner+w=401wt.eu-S1762942AbYHDURL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762942AbYHDURL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbYHDUQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:16:54 -0400
Received: from gw.goop.org ([64.81.55.164]:44891 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696AbYHDUQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:16:53 -0400
Message-ID: <489763AB.1030204@goop.org>
Date: Mon, 04 Aug 2008 13:16:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
References: <20080804130317.994042639@chello.nl>  <20080804131012.246115111@chello.nl>  <48974512.7000206@goop.org> <1217876046.3589.61.camel@twins> <489757EC.3000309@goop.org> <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 4 Aug 2008, Jeremy Fitzhardinge wrote:
>   
>> OK.  I don't actually need to do this, but I was asking for completeness.  But
>> to clarify, you only need to do the reverse unlock if you do it after
>> unlocking the outer lock?  If you're still holding the outer lock, you can
>> unlock in any order?
>>     
>
> Release order should always be totally irrelevant, whether you hold outer 
> locks or not. Only the order of _getting_ locks matter.
>   

Right.  But Peter said lockdep was fussy about it for some reason.  If 
the point of the exercise is to eliminate spurious warnings, it would be 
nice to avoid new ones in the process...

    J
