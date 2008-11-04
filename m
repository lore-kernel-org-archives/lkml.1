Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYKDTK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYKDTK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbYKDTKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:10:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:36157 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbYKDTKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:10:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DIH6qeyGr929vI6J+LawWWN5VCUf3ux6mnItZP4qhZ19S08XRV9tbf+/aqhI9eRL0j
         XPGFgfqtmHA1Ec3JGxSykxHDsZd8kjywHcVOXdGokfKAn387SOh9iIf00oxS2cDHRQmh
         EILCZJRccgHLZGFKvVIiYevEc8AZYdSIfEDDY=
Message-ID: <49109E2B.3030103@gmail.com>
Date: Tue, 04 Nov 2008 21:10:35 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
 belongs to. Store thread group leader id, and use it to lookup the address
 in the process's map. We could have looked up the address on thread's map,
 but the thread might not exist by the time we are called. The process might
 not exist either, but if you are reading trace_pipe, that is unlikely.
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk> <20081103073257.GA13727@elte.hu> <20081104182628.GA6666@infradead.org> <49109657.3000601@gmail.com> <20081104190909.GA22438@infradead.org>
In-Reply-To: <20081104190909.GA22438@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-04 21:09, Christoph Hellwig wrote:
> On Tue, Nov 04, 2008 at 08:37:11PM +0200, T?r?k Edwin wrote:
>   
>> Hmm, this is just for visualizing things in /sys/kernel/debug/, can't I
>> use something simpler than mangle_path, such as a simple while loop like
>> the one below?
>>     
>
> Sounds fine to me, although sharing one mangling-scheme for all pathname
> outputs certainly does have benefits of less confusion for the user.

Indeed. I'll do as you suggested: make mangle_path global and document
what it does.

Best regards,
--Edwin
