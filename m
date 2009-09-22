Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbZIVPTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbZIVPTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZIVPTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:19:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZIVPTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:19:50 -0400
Message-ID: <4AB8EAF2.1030204@zytor.com>
Date: Tue, 22 Sep 2009 08:19:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
References: <4AB3CDEC.5050902@zytor.com> <1253342422-13811-1-git-send-email-avi@redhat.com> <4AB8980D.5070803@redhat.com> <20090922143223.GA31702@elte.hu>
In-Reply-To: <20090922143223.GA31702@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
> 
>> On 09/19/2009 09:40 AM, Avi Kivity wrote:
>>> Add a general per-cpu notifier that is called whenever the kernel is
>>> about to return to userspace.  The notifier uses a thread_info flag
>>> and existing checks, so there is no impact on user return or context
>>> switch fast paths.
>>>    
>> Ingo/Peter?
> 
> Would be nice to convert some existing open-coded return-to-user-space 
> logic to this facility. One such candidate would be lockdep_sys_exit?
> 
> 	Ingo

Sorry, limited bandwidth due to LinuxCon, but I like the concept, and 
the previous (partial) patch was really clean.  I agree with Ingo that 
arch support so we can use this as a general facility would be nice, but 
I don't consider that as a prerequisite for merging.

	-hpa

