Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbZAGUkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbZAGUkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761170AbZAGUkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:40:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41101 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761129AbZAGUkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:40:17 -0500
Message-ID: <496512D2.2030809@redhat.com>
Date: Wed, 07 Jan 2009 15:38:42 -0500
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107171922.GA18000@redhat.com> <alpine.DEB.1.10.0901070949050.16651@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0901070949050.16651@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Wed, 7 Jan 2009, Oleg Nesterov wrote:
> 
>> minor nit...
>>
>> Please note that unlike other sys_...fd() syscalls, sys_waitfd()
>> doesn't allow to pass O_CLOEXEC. Looks like we need a separate
>> "flags" argument...
> 
> I said this even during the first post. Not a minor nit unless we want to 
> have a sys_waitfd2 soon after.
> 

I don't think I properly understood the complaint last time you made it.

Fix on the way

--CJD
