Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYAHXEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYAHXEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYAHXEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:04:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54165 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYAHXEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:04:10 -0500
Date: Wed, 9 Jan 2008 00:06:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl II
Message-ID: <20080108230636.GC2117@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <20080108204214.GA2117@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108204214.GA2117@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would suggest to only work on files that compile. e.g. do a
> 
> make allyesconfig
> make -j$[$(grep -c processor /proc/cpuinfo)*2] &1 |tee LOG             (will probably take a long time) 
>
> first and then only modify files when are mentioned in "LOG" 

Actually since this will probably take very long on a slower machine you can refer to 

http://halobates.de/allyes/

for some allyes buildlogs of recent kernels for i386 and x86-64. A trick to quickly check
if something compiles is also to do

make allyesconfig
make path/to/file.o 

That won't catch linker errors, but if you don't have warnings there are normally no
linker errors either.

-Andi
