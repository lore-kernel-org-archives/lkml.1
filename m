Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbYBZFsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbYBZFsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 00:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYBZFss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 00:48:48 -0500
Received: from ag-out-0708.google.com ([72.14.246.251]:47672 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYBZFsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 00:48:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jhhq2mVEc3OaBlelLsKhhX7p7TEekh/Jy86hHpFwxa4n6bES2C9kIRoWXXGs8PHj0X9u11O4up5RVsSqajwJ39u3Tsp5U9/d8krzLP4t+aNXRpfoYimzOupLjPCla27n5AlLaC2DgLMU1jKZFtwXXeWxvI86CTg0R1Eio48tE/A=
Message-ID: <a8e1da0802252148p43d7b899t25ed0a9f994fae35@mail.gmail.com>
Date: Tue, 26 Feb 2008 13:48:45 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: boot_delay broken ?
Cc: akpm <akpm@linux-foundation.org>, "Dave Jones" <davej@codemonkey.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080225212251.18c4659e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080224004615.GA31012@codemonkey.org.uk>
	 <a8e1da0802241814x48e169f2v82823c55412fc534@mail.gmail.com>
	 <20080225212251.18c4659e.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 1:22 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 25 Feb 2008 10:14:36 +0800 Dave Young wrote:
>
>  > On Sun, Feb 24, 2008 at 8:46 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>  > > The boot_delay switch seems to be behaving strangely in the
>  > >  current -git.  Setting it to =10 makes the output 'bursty'
>  > >  it becomes slow for some printk's whilst others scroll by
>  > >  at regular speed.
>  > >  Setting it any higher than that seems to make it pause for
>  > >  a really long time before it outputs any text at all.
>  >
>  > On my side there's this issue for a long time
>  > http://lkml.org/lkml/2007/8/8/79
>
>  [http://marc.info/?l=linux-kernel&m=118655896515049&w=2]
>
>  You asked questions and they were answered.  Perhaps you didn't like
>  the answers.

No, I like it.  Thanks.

But I still want to know why mdelay can not be used.
is it not available for all archs or something else?

>
>  Here's a question for you.  What kernel boot options did you use?
>  Specifically, for lpj= and boot_delay= ?

I tried boot_delay=100 and boot_delay=200 without lpj set, The result
was really slow. It was better with lpj copied from dmesg, but was
still slower then mdelay.

I think we can firstly use preset lpj, after delay calibrating just
use the system lpj

>
>  > >
>  > >  x86 timer changes perhaps ?
>
>
>  ---
>  ~Randy
>
