Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYAGJYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYAGJYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYAGJYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:24:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:36378 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbYAGJYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:24:35 -0500
Message-ID: <4781EFCE.8000800@qumranet.com>
Date: Mon, 07 Jan 2008 11:24:30 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
CC: kvm-devel@lists.sourceforge.net, Marcelo Tosatti <marcelo@kvack.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 02/33] KVM: MMU: emulated cmpxchg8b should
 be atomic on i386
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>	<1199630379-28638-3-git-send-email-avi@qumranet.com> <20080106185728.GA21491@tapir>
In-Reply-To: <20080106185728.GA21491@tapir>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Marcelo Arenas Belon wrote:
> On Sun, Jan 06, 2008 at 04:39:08PM +0200, Avi Kivity wrote:
>   
>> From: Marcelo Tosatti <marcelo@kvack.org>
>>
>> Emulate cmpxchg8b atomically on i386. This is required to avoid a guest
>> pte walker from seeing a splitted write.
>>
>> [avi: make it compile]
>>
>> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>> ---
>>     
>
> This one doesn't look like the one in the current tree, and avoids the reuse
> of addr by moving the call to get the gpa up instead of renaming the variable
> as propossed in :
>
>   

This is a cumulative patch that is the original patch plus all the fixes 
rolled in.  I'd to avoid churn for style issues at this point, maybe we 
can address it later.

-- 
error compiling committee.c: too many arguments to function

