Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbYE2PEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbYE2PEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYE2PEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:04:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:9199 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYE2PEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ca4rdGj3u0VcXHV9MRuXL/Q/+gnZckLWL/0OZuQx4CQBPdyAScCiM7U9NOUxhCwEbS8ZcvlZemDCJJm2izEQHYSt03JJUScPlQXOdhxiw30CuITHwEgPrkaiZ/1SXiXqlUw2hfYQye/Oa9NaAkJX56Cx7UXRbNzQSOvJi/0jqpY=
Message-ID: <75b57c110805290804p2280a6ffwf68174754db59e9c@mail.gmail.com>
Date: Thu, 29 May 2008 11:04:32 -0400
From: "Gerb Stralko" <gerb.stralko@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: remove CDROM not ready printk
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <1212072912.3428.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
	 <20080529004154.bbc7b1d4.akpm@linux-foundation.org>
	 <1212069932.3428.1.camel@localhost.localdomain>
	 <75b57c110805290735i493eca0fp882f4a38901a416c@mail.gmail.com>
	 <1212072912.3428.28.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 10:55 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2008-05-29 at 10:35 -0400, Gerb Stralko wrote:
>> So is that printk really needed?  Should the kernel even need to print
>> a message like that, esp. if user-space is handling state updates and
>> notifications.  Or do i need to configure hald to be quietier?   FWIW
>> I'm using fedora core 9 and hald version:
>> -bash-3.2$ /usr/sbin/hald --version
>> HAL package version: 0.5.11
>
> Actually, I misspoke; it's set internally via sets of ioctls.  However,
> it's designed only to show on ioctls that do medium requiring things.
>
> I'm also using FC9 and I see no such messages (and for noisy cgc,
> they're printed out for every action on the CD).  You have some
> application that's poking the CD wrongly (probably not hal), so you
> really need to find out what it is.  It may be pointing to some other
> error in the kernel that needs fixing, but simply removing the message
> is covering up the issue.
>
> To help track the application, you could update the printk to print out
> current->comm and current->pid.  That would tell you who is responsible
>
> James
>
>
>
Okay, i'll do some investigation and see if I can track this down,
I'll let you know.   Thanks for the info.

Are you using GNOME or KDE?  I'm currently using KDE.

thanks
