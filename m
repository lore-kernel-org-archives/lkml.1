Return-Path: <linux-kernel-owner+w=401wt.eu-S968488AbXEIFtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968488AbXEIFtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934320AbXEIFs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:48:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:1212 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbXEIFs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RRR1kmZKLZ1wccd44bFzPzWCSDTPQnOYidNwtQ/tqtzhNfW4pAOals5NhYKpdH0iQNLTN9N9aVlyJLaxr6AOqS/zbkWVXjdEzjFD9ys750rBIXR3CBV26BD2A01mo9iyESNNbzh6ZOJsp0zkql8b9q6LVyYKvv+CkP258fbJuzA=
Message-ID: <86802c440705082248r5248aa08s8299e03f615b984a@mail.gmail.com>
Date: Tue, 8 May 2007 22:48:56 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, vgoyal@in.ibm.com,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4641573C.1000205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org> <4640FB2C.2060300@zytor.com>
	 <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
	 <46410403.4050802@zytor.com>
	 <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
	 <46413087.2020505@zytor.com>
	 <m1tzumu10k.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com>
	 <46415640.6000600@zytor.com> <4641573C.1000205@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, H. Peter Anvin <hpa@zytor.com> wrote:
> H. Peter Anvin wrote:
> Of course, one could argue that since all of those were obsolete by the
> time Linux was first created, that it probably doesn't matter and that
> isVGA == 0 pretty much means the more obvious thing.
>
> MDA/HGC stuck around for quite a while for debugging, since it was
> non-conflicting with VGA, but even if it is, the reason people put it in
> their system is to have something that the OS doesn't readily see.
>
so the kexec tools need to scan the pci devices list, and find out how
to set real_mode.isVGA and orig_video_mode, also need to parse the
comand line about vga console.

YH
