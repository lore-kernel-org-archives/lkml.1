Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYD2UqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYD2UqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYD2Ups
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:45:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:23641 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760814AbYD2Upq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BEwBOGD2NIXvpnUOUlXAZoC5us03cQCOHS+Xk51uGHnwDDRoNZU7TbljHNdxVnLk4TiLAlkWYYRc/XR8DeddxfoLEu+J226MQiaa0QfOXTPQFeEjq3xDJgO58WTTpNuoNZBVxMdk9GjQ+orpf4/qpBvQZsSEcs3TH9yYPBLhK40=
Date: Wed, 30 Apr 2008 01:41:07 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mark Rustad <mrustad@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Timur Tabi <timur@freescale.com>,
       Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Why use /bin/sh in kernel build system?
Message-ID: <20080429214107.GA22735@martell.zuzino.mipt.ru>
References: <481529B6.6030802@freescale.com> <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de> <48173607.6080307@freescale.com> <20080429164501.GA18018@uranus.ravnborg.org> <F963C774-E80A-48C6-AC86-681232CEE6CF@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F963C774-E80A-48C6-AC86-681232CEE6CF@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 03:27:02PM -0500, Mark Rustad wrote:
> On Apr 29, 2008, at 11:45 AM, Sam Ravnborg wrote:
>
>>> I read in the latest Linux Journal magazine that someone noticed that 
>>> even
>>> though the kernel scripts say #!/bin/sh, many of them are really bash 
>>> scripts.
>>> This person went through the effort of changing the script to be true 
>>> 'sh'
>>> scripts.  Has that code been merged in?
>>
>> I have no patches pending but I may have lost them.
>> As I am 100% ignorant about what is bash and what is not bash specialities
>> I will more or less be blind when I apply them so I hope they are well
>> tested.
>
>
> So why use /bin/sh ever in the kernel build system? I consciously began 
> using /bin/bash consistently in scripts years ago because you just never 
> know what you get when you use /bin/sh. I remember replacing /bin/sh with 
> /bin/bash in gcc's build system to get it to work on some system at some 
> point. Life is too short to keep having to fight silliness like this and I 
> can't see a valid reason why a system building a Linux kernel, or for that 
> matter gcc, should not have the bash shell installed on it.

Think harder.

> And on some systems, changing /bin/sh to point to /bin/bash can result in 
> subtle problems with that system's environment, so that is not a good 
> option. At least by using /bin/bash you know what you get and the 
> dependency is then known to all.

