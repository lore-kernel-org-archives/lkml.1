Return-Path: <linux-kernel-owner+w=401wt.eu-S1762764AbXGFQL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762764AbXGFQL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXGFQLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:11:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbXGFQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:11:20 -0400
Message-ID: <468E699C.1000502@zytor.com>
Date: Fri, 06 Jul 2007 09:11:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gautam Singaraju <gautam.singaraju@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: syscall macro fails upon compilation
References: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com>	<468D6D1F.4040008@zytor.com> <p73r6nl21fe.fsf@bingen.suse.de>
In-Reply-To: <p73r6nl21fe.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> Gautam Singaraju wrote:
>>> I use the _syscall0 macro.
>> Don't.  The _syscall*() macros have been unsupported for ages,
> 
> That's not true. I supported them on x86 before they were removed against
> my objections.
> 
>> and broken for ever longer.
> 
> Well, most syscall() versions get 6 argument calls wrong
> (not sure if that is finally fixed). _syscall*() didn't support
> -fPIC for larger argument counts (_syscall0-2 never had a problem) 
> 
> So all alternatives short of writing your own stub had various
> issues. If you needed 6 argument calls _syscall* was typically
> the best alternative.
> 

They were *always* broken for 64-bit arguments on 32-bit machines, however.

	-hpa
