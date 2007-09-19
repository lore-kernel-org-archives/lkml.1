Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbXISUCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbXISUCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbXISUCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:02:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:32209 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXISUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=B+B46CXpsuZzvbshEsiiMa7Nvv6sqMSN/rKqi+xij9jLeo3nUPiIADZhqJ8Fuh2fZ9lDnnX8jaWrISjoVmDfY78T7wGsIJsBA7tgtBZjaI2Y94ut/XsQhhN5sfc+oKcaRHcfm8vv+6PGijCXsfKIY38cHCj5xJJJEa72crAnDGw=
Message-ID: <46F18037.1020505@gmail.com>
Date: Wed, 19 Sep 2007 22:01:59 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <46F17CA1.5080205@gmail.com> <20070919195425.GF18707@one.firstfloor.org> <46F17F27.5080000@gmail.com>
In-Reply-To: <46F17F27.5080000@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2007 09:57 PM, Jiri Slaby wrote:
> On 09/19/2007 09:54 PM, Andi Kleen wrote:
>>> Yeah. (But X doesn't run -- this is maybe the known issue in this release).
>> What do you mean with not run? 
> 
> (II) intel(0): Initializing HW Cursor
> (II) intel(0): xf86BindGARTMemory: bind key 0 at 0x005ff000 (pgoffset 1535)
> (WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
>         at offset 0x5ff000 failed (Invalid argument)
> 
> Fatal server error:
> Couldn't bind memory for front buffer

Further info:
4690  write(0, "(II) intel(0): Initializing HW C"..., 38) = 38
4690  write(0, "(II) intel(0): xf86BindGARTMemor"..., 76) = 76
4690  ioctl(9, AGPIOC_BIND, 0x7fffbe1cb850) = -1 EINVAL (Invalid argument)
4690  write(0, "(WW) intel(0): xf86BindGARTMemor"..., 115) = 115
4690  write(2, "\nFatal server error:\n", 21) = 21

> I thought I'd seen a thread about this issue, but I can't find it now. Is it
> known or am I seeing ghosts yet, Andrew?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
