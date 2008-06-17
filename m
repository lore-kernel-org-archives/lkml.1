Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbYFQNxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbYFQNxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbYFQNxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 09:53:12 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:38530 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757759AbYFQNxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 09:53:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAL1cV0hMQW1O/2dsb2JhbACBW60T
Date: Tue, 17 Jun 2008 09:53:09 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, tzanussi@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
	logging.
Message-ID: <20080617135309.GB10316@Krystal>
References: <20080613041013.274ccb28@linux360.ro> <48521C19.6070001@cs.helsinki.fi> <20080613185414.306b4baa@linux360.ro> <20080616123003.GC18561@Krystal> <20080616163707.37846652@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080616163707.37846652@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:52:48 up 12 days, 18:33,  4 users,  load average: 0.39, 0.40,
	0.37
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Mon, 16 Jun 2008 08:30:03 -0400
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > If you need to "emulate" having many CPUs, Xen is always an option.
> 
> I'd rather set up a QEMU environment than rebase this on Xen.
>   
> > Hrm, sounds like a bad idea... please try getting a test setup
> > working, it will save you a gazillion iterations and let you
> > stress-test your code.
> 
> Check your mailbox, I resubmitted the buffer-only channels along with
> hotplug fixes. I couldn't test on my machine all hotplug has to offer,
> but hotplug does create the buffers correctly when the kernel goes SMP.
>  

testing cpu hotplug with online/offline cycling should be done too.

Mathieu

> 
> 	Eduard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
