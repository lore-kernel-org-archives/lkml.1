Return-Path: <linux-kernel-owner+w=401wt.eu-S1765453AbYBVTHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765453AbYBVTHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757470AbYBVTHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:07:35 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:44650 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbYBVTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:07:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sm/wfYDaZrE1p1YOmscIh/aIfn0RtmsRqWvyUtRVPoWlcjr1pe/N/CHORbStHi+nhzJ7/HbBo1tJY8b1f3Bjkz8p1Z6ApDYhEoVox0X7L5cYgYFfSlqsmrWQ463guHSXuKmTRqbq41bIBgMkKS6ukl2wKMuqDXrGKN08cV7c2do=
Message-ID: <86802c440802221107o713c264aj6ba7e37489df17a@mail.gmail.com>
Date: Fri, 22 Feb 2008 11:07:31 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47BF1D66.20507@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
	 <p73hcg189g1.fsf@bingen.suse.de>
	 <200802221102.31019.yinghai.lu@sun.com>
	 <47BF1BD9.4020808@firstfloor.org>
	 <86802c440802221104m3db0260cj806eb4fbd2a0db82@mail.gmail.com>
	 <47BF1D66.20507@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:07 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Yinghai Lu wrote:
>  > On Fri, Feb 22, 2008 at 11:00 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  >>  > so for that box [4, 0x23] still could be apic clustered? there is a hole [0,3]..
>  >>
>  >>  I meant holes between the CPUs only, not including the IO-APICs.
>  >>
>  >>
>  >>  > is their box using AMD cpu or not?
>  >>
>  >>  Intel. AMD boxes don't really need clustered mode because they support
>  >>  bigflat mode.
>  >
>  > So DMI or exclude AMD CPU?
>
>  Just check for holes between the cpus as I suggested earlier

how about their system that is not full populated with CPU?

YH
