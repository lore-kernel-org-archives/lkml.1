Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZLXM4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZLXM4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZLXM4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:56:47 -0500
Received: from mail.klingt.org ([86.59.21.178]:50171 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbZLXM4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:56:47 -0500
Message-ID: <4B3364DE.6080907@klingt.org>
Date: Thu, 24 Dec 2009 13:55:58 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7pre) Gecko/20091219 Shredder/3.0.1pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org> <4B2A93F2.3070407@klingt.org> <4B2AFBB1.3040609@kernel.org> <4B2B4838.6080509@klingt.org> <4B2F20E0.30804@kernel.org> <4B2F40C0.5020407@klingt.org> <4B33592B.6000107@kernel.org> <4B335964.6040202@klingt.org> <4B335DE6.9030102@kernel.org> <4B336303.2090403@kernel.org>
In-Reply-To: <4B336303.2090403@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Thu, 24 Dec 2009 13:56:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sections aren't supposed to have addresses assigned in relocatable
>> output and it of course breaks things.  I'll try newer version of
>> binutils but at this point it looks like a linker bug.  Can you please
>> report it to ubuntu too?
>
> I just tried 2.20 on openSUSE.
>
>   $ ld --version
>   GNU ld (GNU Binutils; devel:gcc / openSUSE_11.2) 2.20.0.20091104-13.2
>   Copyright 2009 Free Software Foundation, Inc.
>   This program is free software; you may redistribute it under the terms of
>   the GNU General Public License version 3 or (at your option) a later version.
>   This program has absolutely no warranty.
>
> and it doesn't show such behavior.  Can you please report this to
> ubuntu and let me know the bug#?

https://bugs.launchpad.net/ubuntu/+source/binutils/+bug/500113

i will double-check on the other machine in a few days ... it may be, 
that i am using a toolchain ppa, that installed some unstable/odd/buggy 
binutils ...
but i somehow doubt, that this is the case :/

cheers, tim

-- 
tim@klingt.org
http://tim.klingt.org

Just what the hell is the experimental tradition?
   Morton Feldman
