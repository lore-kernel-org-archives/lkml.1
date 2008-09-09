Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYIISNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYIISNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYIISMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:12:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYIISMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:12:53 -0400
Message-ID: <48C6BC99.1030107@zytor.com>
Date: Tue, 09 Sep 2008 11:12:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <20080909165728.GD30160@cs181140183.pp.htv.fi> <48C6AC79.3000003@zytor.com> <20080909174333.GE30160@cs181140183.pp.htv.fi>
In-Reply-To: <20080909174333.GE30160@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>> Well, for one thing, gcc doesn't actually pass the -mtune= option to  
>> gas, it turns out.
> 
> What caused gas to emit the "wrong" NOPs?

It doesn't, after all, with the current gcc driver.  A future gcc driver 
may change that.  Of course, now when this has popped up on the radar 
screen, it might not happen.

>> But yes, "-Wa,-march=generic32" is really the proper fix.
> 
> If I understand the binutils changelog correctly -march=generic32 
> support was added one week before the NOP code in question, so all 
> affected binutils versions support it.

s/-march/-mtune/, but yes.  I suspect it was actually added *in order* 
to support the NOP code.

	-hpa
