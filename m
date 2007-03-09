Return-Path: <linux-kernel-owner+w=401wt.eu-S965025AbXCIBVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbXCIBVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 20:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965072AbXCIBVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 20:21:44 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:34701 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbXCIBVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 20:21:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mp9dEZmqvyVRsSQ9k//ZkNVeQjfApYMAllZrZ5GOqdm3y599VZ5l2qxBDCKOlXVUIGl1NwEsGiPTtJQWmwnu5gFT2DH+Gbrh6sqHRRwXJKSm+uqS/HbhIaKzKd6ptzx9UGw/NYjgvBsWTnMbj68slzP7G/G2LJ1jklM8Ry+pAi4=
Message-ID: <75b66ecd0703081721y75abccbet32a3c5de906132c8@mail.gmail.com>
Date: Thu, 8 Mar 2007 20:21:42 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: KVM and rtc missing interupts 2.6.21-rc3
Cc: "David Brown" <dmlb2000@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <adatzwvxuta.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c21eeae0703081348i713c996bked9ebe2af76bc2db@mail.gmail.com>
	 <adatzwvxuta.fsf@cisco.com>
X-Google-Sender-Auth: 08b32e2a63805d11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > When ever I try and start a guest OS with kvm I get a lot of these rtc
>  > missing interupt messages from the kernel
>  >
>  > [  468.510878] rtc: lost some interrupts at 1024Hz.
>
> I started to debug this a little while ago but I never got too far.
> However it doesn't seem connected with kvm -- it is something to do
> with tun/tap or bridging holding a lock too long I think.

Holding a lock too long should be easy to debug with the -rt patch -
set the preemption related options to match mainline, and enable the
latency tracer.

Lee
