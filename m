Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbXA3Dco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbXA3Dco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXA3Dco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:32:44 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:64992 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXA3Dcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:32:43 -0500
Date: Mon, 29 Jan 2007 22:27:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Martin J. Bligh" <mbligh@mbligh.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug report : reproducible memory bug (hardware failure, sorry)
Message-ID: <20070130032734.GA28701@Krystal>
References: <20070128200917.GA16571@Krystal> <45BD06AC.1080008@mbligh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <45BD06AC.1080008@mbligh.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 22:21:18 up 160 days, 28 min,  2 users,  load average: 0.58, 0.80, 0.62
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin J. Bligh (mbligh@mbligh.org) wrote:
> Mathieu Desnoyers wrote:
> >Hi,
> >
> >Trying to build cross-compilers (or kernels) on a 2-way x86_64 (amd64) with
> >make -j3 triggers the following OOPS after about 30 minutes on
> >2.6.19.2. Due to the amount of time and the heavy load it takes before it
> >happens, I suspect a race condition. Memtest86 tests passed ok. The
> >amount of swap used when the condition happens is about 52k and stable
> >(only ~800MB/1GB are used).
> >
> >I am going to give it a look, but I suspect you might help narrowing it
> >down more quickly. Any insight would be appreciated.
> 
> Mmm. that's going to be messy to debug ... but didn't we already know
> that kernel was racy? Or is 2.6.19.2 after that fix already? Does 20-rc6
> still break?

Hi Martin,

I finally re-ran memtest86 on the machine since it began to have too
many different kind of errors (GPF, invalid instruction...). It turned
out that one of the memory modules was bad. I guess my brand new 
list_debug race condition debugger will be useful in the future, but not
now. :)

I'll remember to let memtest86 run a few hours more on my new machines
next time.

Mathieu

-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
