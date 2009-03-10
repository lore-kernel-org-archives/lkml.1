Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZCJIgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZCJIgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 04:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZCJIgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 04:36:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48661 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbZCJIgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 04:36:41 -0400
Message-ID: <49B6268C.2030300@redhat.com>
Date: Tue, 10 Mar 2009 10:36:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Jeff Moyer <jmoyer@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit
 to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com> <49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B571C7.3010005@redhat.com> <20090309203624.GA2812@shareable.org>
In-Reply-To: <20090309203624.GA2812@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Avi Kivity wrote:
>   
>> Or you could queue the completions somewhere, and only copy them to
>> user memory when io_getevents() is called.  I think the plan was
>> once to allow events to be consumed opportunistically even without
>> io_getevents(), though.
>>     
>
> Isn't that integrated (or to be integrated) with the vring buffer
> thingy used by virtio?
>
> If not, should it be?
>
>   

vringfd has been abandoned, AFAICT.  I think it's too similar to aio anyway.


-- 
error compiling committee.c: too many arguments to function

