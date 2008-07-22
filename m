Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYGVEve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYGVEve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYGVEvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:51:25 -0400
Received: from gw.goop.org ([64.81.55.164]:46617 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYGVEvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:51:24 -0400
Message-ID: <48856741.6040606@goop.org>
Date: Mon, 21 Jul 2008 21:51:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix pte_flags() to only return flags, fix lguest.
References: <200807221431.58991.rusty@rustcorp.com.au> <20080722143800.d392994f.sfr@canb.auug.org.au>
In-Reply-To: <20080722143800.d392994f.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Just a small point:  You don't actually need the _AC() because this is
> already in a #ifndef __ASSEMBLY__ section of the file.  But better safe
> than sorry, I guess.  :-)
>   

It's doubly wrong anyway.  The correct thing to use here would be 
_AT(pteval_t, 0x80....FFF), but even more correct to use PTE_MASK which 
is already defined to have precisely this meaning.

    J
