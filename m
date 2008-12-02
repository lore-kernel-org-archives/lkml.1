Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYLBUlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYLBUlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLBUkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:40:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbYLBUky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:40:54 -0500
Date: Tue, 2 Dec 2008 12:40:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       "Michael B. Trausch" <mike@trausch.us>
Subject: Re: Linux 2.6.28-rc7
In-Reply-To: <20081202204503.57363502@varda>
Message-ID: <alpine.LFD.2.00.0812021237310.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda> <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org> <20081202165637.09984819@varda> <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
 <20081202194907.4eaffc0a@varda> <alpine.LFD.2.00.0812021120110.3256@nehalem.linux-foundation.org> <20081202204503.57363502@varda>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Alejandro Riveira Fernández wrote:
> 
>  Well i already sent the result of the revert on another mail;
> it did not help :(

Ahh. Oh, well.

>  I tried again with what i thought was my "good" commit and the
> bug is there too :/
> 
>  could it be that something changed in userspace[1] between the
> day i installed the 2.6.28-rc6-00007-ged31348 and today that
> make this bug trigger?

Sure, that's possible. It happens occasionally with updated user-land 
binaries, especially system-related ones (eg something like X or SElinux 
or whatever).

Or perhaps a configuration change meant that if you recompiled the "good" 
kernel, you now recompiled a different config? Or did you re-use the exact 
same kernel image you had originally?

>  Next step is try to find an "actually good" kernel and bisect
> again sigh... 2.6.27.6 seems to work ok

Ok, that's a much bigger bisection thing, but again, even just narrowing 
it down a bit will help. But check the configuration too before you start.

			Linus
