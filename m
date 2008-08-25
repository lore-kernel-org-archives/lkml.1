Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYHYKXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYHYKXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYHYKXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:23:32 -0400
Received: from il.qumranet.com ([212.179.150.194]:23523 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbYHYKXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:23:31 -0400
Message-ID: <48B28822.1010103@qumranet.com>
Date: Mon, 25 Aug 2008 13:23:30 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #11254] KVM: fix userspace ABI breakage
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.mGB.TcGsIB@albercik> <20080824192714.GC1627@cs181140183.pp.htv.fi>
In-Reply-To: <20080824192714.GC1627@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The discussion in Bugzilla whether it is a regression at all can be 
> condensed to the following question:
>
> Can a struct that is part of the 2.6.26 userspace headers be defined to 
> be part of an "experimental ABI" and therefore be changed?
>   

It is part of the experimental ABI.

However, as I'm going to apply your patch (as being the simplest fix, 
and as there is no measurable performance impact), the question is moot.

-- 
error compiling committee.c: too many arguments to function

