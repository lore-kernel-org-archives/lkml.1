Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbYC0T6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbYC0T6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbYC0T6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:58:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:39356 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbYC0T6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oyC5rjdQ3c5/J4nYmiX9lDsGDtj06SbmMlOMeZbuZfoN8Zb20W+TZ6GNb3By67OYNkj61bbPrpKc/cnFgo3Of9pjEqYcB1W3Fc5zR13I5ngiVKcTKL80JPLIF+XcukNWQ3txTXA4wmoBJ23CgQj8lGI2iCuabn/p7xXIUvDb8pU=
Date: Thu, 27 Mar 2008 22:56:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: processor flags
Message-ID: <20080327195656.GB7633@cvg>
References: <20080327194749.GA7633@cvg> <47EBFBBE.4060404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EBFBBE.4060404@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Thu, Mar 27, 2008 at 12:55:42PM -0700]
> Cyrill Gorcunov wrote:
>> And now I'm in confusion - the way of changing this code I see is the
>> following:
>> - or use additional #ifdef CONFIG_VM86 in code where VM_MASK is used
>>   (that would be ugly IMHO)
>> - rename VM_MASK to say X86_EFLAGS_VM86 with that #ifdef remained
>> - rest VM_MASK as it is
>> How do you think?
>
> I think what we should do is:
>
> - Rename VM_MASK to X86_VM_MASK (it's x86-specific after all)
> - Have:
>
> #if CONFIG_VM86
> # define X86_VM_MASK X86_EFLAGS_VM
> #else
> # define X86_VM_MASK 0		/* No V86 support */
> #endif
>
> 	-hpa
>

Thanks a lot, Peter

		- Cyrill -
