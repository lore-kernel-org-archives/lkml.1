Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYCLOHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYCLOHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYCLOHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:07:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:39299 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYCLOHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=j0NWDPuANJS7czJTuVC/b3l/o4F9HWTdZZJ8IgszC7Mkf2kUAh3ls7CunxRx6ha3yqiIvnrB9StvKNXmP0Hz4hqO1DEr1U74Iyz9p8xUav4GSij2RvJQcWgcS/9L6a0RcnOBA4/f+k14SiVGOa9JeV/7Btr/lrfPDaBVlzI/JD0=
Message-ID: <47D7E392.3080807@gmail.com>
Date: Wed, 12 Mar 2008 15:07:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Mark early_printk as asmlinkage
References: <1205330034-28828-1-git-send-email-jirislaby@gmail.com> <1205330034-28828-2-git-send-email-jirislaby@gmail.com> <47D7E2FB.2020801@zytor.com>
In-Reply-To: <47D7E2FB.2020801@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2008 03:04 PM, H. Peter Anvin wrote:
> Jiri Slaby wrote:
>> It's not explicitly marked as asmlinkage, but invoked from x86_32
>> startup code with parameters on stack.
>>
>> No other architectures define early_printk and none of them are affected
>> by this change, since defines asmlinkage as empty token.
> 
> NAK.
> 
> The regparm ABI for x86-32 uses parameters on the stack when the 
> function is varadic (as it is here), so this is unnecessary.

Makes sense. Why is printk marked as asmlinkage?
