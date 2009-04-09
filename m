Return-Path: <linux-kernel-owner+w=401wt.eu-S1759267AbZDIHky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbZDIHky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZDIHkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:40:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36143 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZDIHkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:40:41 -0400
Message-ID: <49DDA69F.9040808@redhat.com>
Date: Thu, 09 Apr 2009 10:41:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] disable interrupt shadow state for emulated instruction
References: <1239213452-5966-1-git-send-email-glommer@redhat.com> <49DCE9E5.8020703@zytor.com> <20090408183110.GD25323@poweredge.glommer>
In-Reply-To: <20090408183110.GD25323@poweredge.glommer>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
>> How does this logic work when the instruction emulated is an STI or MOV  
>> SS instruction?  In particular, when does GUEST_INTERRUPTIBILITY_INFO  
>> sets set to reflect the *blocking* operation?
>>     
> mov ss is a non-issue, since it is executed natively.
>   

Except in big real mode (needs emulate_invalid_guest_state = 1).

> As for sti, I'm not sure. I see code for emulating sti, but in my testings,
> this code was never ever touched, under a number of different scenarios.
> Avi, can you clarify if sti can be in fact emulated, and under which
> circunstamces? 
>   

big real mode only.



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

