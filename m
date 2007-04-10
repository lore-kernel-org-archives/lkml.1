Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbXDJWtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbXDJWtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXDJWte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:49:34 -0400
Received: from gw.goop.org ([64.81.55.164]:33853 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbXDJWte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:49:34 -0400
Message-ID: <461C1470.60308@goop.org>
Date: Tue, 10 Apr 2007 15:49:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/2] Allow percpu variables to be page-aligned
References: <461BC4B8.40902@goop.org> <m16483yinf.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m16483yinf.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> Let's allow page-alignment in general for per-cpu data (wanted by Xen, and
>> Ingo suggested KVM as well).
>>
>> Because larger alignments can use more room, we increase the max per-cpu
>> memory to 64k rather than 32k: it's getting a little tight.
>>     
>
> The second paragraph of the comment is dated.  You are not changing the per-cpu 
> memory size at all now.
>   

Yup.

> Although we should probably fail the module load if the requested alignment
> is to great, but that is just picking nits, and is no worse than what we
> do today.
>   

Yes.  And we barely support a module's use of page-aligned data, since
it would potentially chew through the percpu space very quickly.

    J
