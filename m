Return-Path: <linux-kernel-owner+w=401wt.eu-S1764769AbYBVTE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764769AbYBVTE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYBVTEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:04:09 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:42230 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbYBVTEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pg5YKJp9CgI7dTE9EhLRZ832R7OO6NA2MCx6URxe7H2EM8AvIcqmctmfvB0GmKhHWZVECEwoT9Fisl31gdT0WA19vjASgTExhLWqHqNSfQaBXuPLQIlemFe6AhN+fUrH9qaq0HJ3Mhd8tz828gfYXlcPTIK7mBuyCuH7BHX+SXw=
Message-ID: <86802c440802221104m3db0260cj806eb4fbd2a0db82@mail.gmail.com>
Date: Fri, 22 Feb 2008 11:04:03 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47BF1BD9.4020808@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
	 <p73hcg189g1.fsf@bingen.suse.de>
	 <200802221102.31019.yinghai.lu@sun.com>
	 <47BF1BD9.4020808@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:00 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
>  > so for that box [4, 0x23] still could be apic clustered? there is a hole [0,3]..
>
>  I meant holes between the CPUs only, not including the IO-APICs.
>
>
>  > is their box using AMD cpu or not?
>
>  Intel. AMD boxes don't really need clustered mode because they support
>  bigflat mode.

So DMI or exclude AMD CPU?

YH
