Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYGYS6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYGYS6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYGYS6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:58:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50874 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYGYS6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:58:45 -0400
Message-ID: <488A223F.80709@zytor.com>
Date: Fri, 25 Jul 2008 14:58:07 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] byteorder: force in-place endian conversion to always
 evaluate args
References: <1217003621.5971.4.camel@brick>  <488A17EC.2000107@zytor.com> <1217009975.5971.21.camel@brick>
In-Reply-To: <1217009975.5971.21.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
>> For what it's worth, the way to write a macro like this:
>>
>> #define __cpu_to_be64s(x) ((void)(x))
> 
> If you've looked at the byteorder rework I've done in -mm, these get
> unified in a single include/linux/byteorder.h and look like:

[inline functions]

What I meant with the above, was that it seems poorly understood how to 
write an empty "function-like" macro.

Obviously, inline functions don't have this problem, and is generally 
better anyway (type-safe even in the empty condition, for example.)

	-hpa

