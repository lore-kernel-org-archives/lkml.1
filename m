Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbZGRGHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbZGRGHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 02:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZGRGHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 02:07:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50134 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZGRGHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 02:07:49 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Duplicate vsyscall/vdso gettimeofday implementations on x86_64
From: Andi Kleen <andi@firstfloor.org>
References: <1247868130.8334.40.camel@localhost.localdomain>
	<87eisfvtzv.fsf@basil.nowhere.org>
	<1247871284.8334.42.camel@localhost.localdomain>
Date: Sat, 18 Jul 2009 08:07:44 +0200
In-Reply-To: <1247871284.8334.42.camel@localhost.localdomain> (john stultz's message of "Fri, 17 Jul 2009 15:54:44 -0700")
Message-ID: <87ab32wmkv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> writes:
>
> Hrmm. Can we deprecate the old method and push glibc to use the new one?

That would break every old 64bit executable. Also not there are programs
who don't use glibc.

Also glibc's way of calling the vDSO is still somewhat inefficient
(although that could be probably fixed)

> If we remove it the vsyscall interface will old glibc's fall-back
> gracefully? 

They would crash gracefully.

I had a couple of different transition plans, but they were all fairly
complicated and had various disadvantages, so in the end nothing got
done and the old code just left in.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
