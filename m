Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXLMVbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXLMVbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764111AbXLMVbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:31:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbXLMVbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:31:14 -0500
Message-ID: <4761A385.1080301@zytor.com>
Date: Thu, 13 Dec 2007 13:26:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, zach@vmware.com,
       roland@redhat.com
Subject: Re: [PATCH] avoid ifdefs in desc.h, getting rid of pack_ldt and	pack_tss
References: <11975561713425-git-send-email-gcosta@redhat.com> <20071213202800.GD25130@elte.hu> <20071213205838.GA9649@elte.hu> <20071213212221.GA16747@elte.hu>
In-Reply-To: <20071213212221.GA16747@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
>> could we _please_ use basic tools as vmlinux size comparison and 
>> objcompare when unifying, to make sure it's a 100% identity 
>> conversion?
> 
> case in point, the patch claims:
> 
>>> No functional change is made.
> 
> but vmlinux before/after size comparison shows:
> 
>     text    data     bss     dec     hex filename
>  8802894 1224910 3526656 13554460         ced31c vmlinux.before
>  8803042 1224910 3526656 13554608         ced3b0 vmlinux.after
> 

Well, "no functional changes" is not quite the same thing as "no object 
code changes".

	-hpa
