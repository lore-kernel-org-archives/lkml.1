Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbXGFPzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbXGFPzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760184AbXGFPz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:55:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:39636 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbXGFPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aliNTZtDYmV7leVXQuRHOldZvuKgixUZgDYEV2f/9cKH8Rkp52KCaGc2tZAz4jwEMQiAyXzxQuYspzslNsBZlCO4ilObE/Yr0Vjp2PiLinpKRETHBDG1a5a0y7kqd6fNvAopGS4TbL3sPCTTIANJv42wQjiomWv5tgDy9olPX4Y=
Message-ID: <f8b2ccd40707060855o33f1db48v2139ed909e774066@mail.gmail.com>
Date: Fri, 6 Jul 2007 08:55:27 -0700
From: "Gautam Singaraju" <gautam.singaraju@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: syscall macro fails upon compilation
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <p73r6nl21fe.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>
	 <468D6D1F.4040008@zytor.com> <p73r6nl21fe.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am surprised that syscalls have been removed. Anyway, I plan to
write a device node with read and write functions just so that I can
call a method from a user space. What are my other choices?
--
Gautam

On 06 Jul 2007 13:53:41 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>
> > Gautam Singaraju wrote:
> > > I use the _syscall0 macro.
> >
> > Don't.  The _syscall*() macros have been unsupported for ages,
>
> That's not true. I supported them on x86 before they were removed against
> my objections.
>
> > and broken for ever longer.
>
> Well, most syscall() versions get 6 argument calls wrong
> (not sure if that is finally fixed). _syscall*() didn't support
> -fPIC for larger argument counts (_syscall0-2 never had a problem)
>
> So all alternatives short of writing your own stub had various
> issues. If you needed 6 argument calls _syscall* was typically
> the best alternative.
>
> -Andi
>


-- 
---
Gautam
