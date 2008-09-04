Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYIDSrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYIDSrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbYIDSmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:42:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38026 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816AbYIDSl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:41:59 -0400
Message-ID: <48C02A33.20808@zytor.com>
Date: Thu, 04 Sep 2008 11:34:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Daniel Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
References: <20080904150339.896115280@linutronix.de>	 <20080904153620.GC7120@elte.hu>	 <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>	 <1220549961.11753.22.camel@alok-dev1>	 <alpine.LFD.1.10.0809041044160.3400@nehalem.linux-foundation.org> <1220553103.11753.39.camel@alok-dev1>
In-Reply-To: <1220553103.11753.39.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> In the long run though, I think to get rid of all this complexity, we
> can think of getting the frequency from the hypervisor. Lets see, i will
> try making a patch maybe early next week and send it for the x86 tree.
> 

That should go along with a paravirtualized (virtio) timesource.

	-hpa
