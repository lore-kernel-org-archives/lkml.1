Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbXEIQb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbXEIQb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXEIQbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:31:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:47170 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbXEIQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bDlO8PitCAAVwHNGUOg+uFrbPhbd0RKhJgZfYQ0tdYt968rROhvQO7keBb8OlO0VpnwsQSO5LJCRiTQHrB2NDl+V3yChDGo4+SgGaefIpzpVW459UewiRtXnXy+ANri/fZapiZ4EOho8+zIjwzW9vDkwpDyQL8vyjZje/mIIWaE=
Message-ID: <86802c440705090931v39cb355cma06ccbc90954baeb@mail.gmail.com>
Date: Wed, 9 May 2007 09:31:48 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       vgoyal@in.ibm.com, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Jeff Garzik" <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <m1abwetgkn.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org>
	 <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
	 <46413087.2020505@zytor.com>
	 <m1tzumu10k.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com>
	 <46415640.6000600@zytor.com> <4641573C.1000205@zytor.com>
	 <86802c440705082248r5248aa08s8299e03f615b984a@mail.gmail.com>
	 <46416246.9090005@zytor.com>
	 <m1abwetgkn.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> We can look in /proc/ioports and see what has reserved
> the video resources.  That should give us a reasonable
> estimate of the video adapter.  We can do an ioctl to
> the console and see how many lines and columns we have.
>
> Reusing boot_params could be nice but if we have the information
> available in other ways digging it out that way is quite possibly
> better.

Another path:
LiuxBIOS+elfboot+payload, and payload is compressed elf
(vmlinux+initrd) via lzma.
and use kexec to boot final production kernel.
We don't need to use boot_params from the first tiny kernel.

YH
