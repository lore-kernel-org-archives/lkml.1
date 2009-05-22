Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZEVVDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZEVVDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZEVVDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:03:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44557 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbZEVVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:03:41 -0400
Message-ID: <4A171221.5020800@zytor.com>
Date: Fri, 22 May 2009 13:59:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Max Kellermann <mk@cm4all.com>
CC: Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org,
       ijc@hellion.org.uk, Grant Coady <grant_lkml@dodo.com.au>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
 120 seconds"
References: <20081017123207.GA14979@rabbit.intern.cm-ag> <20081017143301.GA18522@poweredge.glommer> <20081020065149.GA11213@rabbit.intern.cm-ag>
In-Reply-To: <20081020065149.GA11213@rabbit.intern.cm-ag>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann wrote:
> On 2008/10/17 16:33, Glauber Costa <glommer@redhat.com> wrote:
>> That's probably something related to apic congestion.
>> Does the problem go away if the only thing you change is this:
>>
>>
>>> @@ -891,11 +897,6 @@ do_rest:
>>>  		store_NMI_vector(&nmi_high, &nmi_low);
>>>  
>>>  		smpboot_setup_warm_reset_vector(start_ip);
>>> -		/*
>>> -		 * Be paranoid about clearing APIC errors.
>>> -	 	*/
>>> -		apic_write(APIC_ESR, 0);
>>> -		apic_read(APIC_ESR);
>>>  	}
>>
>> Please let me know.
> 
> Hello Glauber,
> 
> I have rebooted the server with 2.6.27.1 + this patchlet an hour ago.
> No problems since.
> 
> Hardware: Compaq P4 Xeon server, Broadcom CMIC-WS / CIOB-X2 board.
> Tell me if you need more detailed information.
> 

I was just pointed to this thread in the archives, and I'm really
wondering what was going on here.  In particular, if this machine still
is around, I would appreciate a dump of /proc/cpuinfo as well as
dmidecode from this machine.

Thanks,

	-hpa
