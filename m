Return-Path: <linux-kernel-owner+w=401wt.eu-S932766AbXLMVwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbXLMVwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933677AbXLMVw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:52:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661AbXLMVwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:52:25 -0500
Message-ID: <4761A944.1050503@redhat.com>
Date: Thu, 13 Dec 2007 19:51:00 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH] avoid ifdefs in desc.h, getting rid of pack_ldt and	pack_tss
References: <11975561713425-git-send-email-gcosta@redhat.com> <20071213202800.GD25130@elte.hu> <20071213205838.GA9649@elte.hu> <20071213212221.GA16747@elte.hu> <4761A385.1080301@zytor.com> <20071213213517.GA25563@elte.hu> <4761A6E7.7030602@zytor.com>
In-Reply-To: <4761A6E7.7030602@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>>> Well, "no functional changes" is not quite the same thing as "no 
>>> object code changes".
>>
>> yeah, true, but the safest way to ensure no functional changes is to 
>> get identical object code. In sched-devel.git i include obj 
>> comparisons to cleanup patches as a self-assurance (and later bughunt 
>> helper) to make sure a cleanup is really just a cleanup.
> 
> Of course.  "No object code changes" is a stronger statement, however, 
> not all types of cleanups result in that.
> 
Which is the case here. I wasn't expecting the same object code. Anyway, 
the mistake is explained, and I'm about to send the correct version. 
Sorry again.
