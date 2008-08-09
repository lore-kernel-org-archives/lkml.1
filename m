Return-Path: <linux-kernel-owner+w=401wt.eu-S1760619AbYHIBUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619AbYHIBUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYHIBUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:20:43 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:46879 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYHIBUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:20:43 -0400
Message-ID: <489CF0CE.1000603@cs.columbia.edu>
Date: Fri, 08 Aug 2008 21:20:14 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Arnd Bergmann <arnd@arndb.de>, containers@lists.linux-foundation.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
References: <20080807224033.FFB3A2C1@kernel>	 <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu>	 <200808090029.28286.arnd@arndb.de>  <489CD0F9.9060603@cs.columbia.edu> <1218242286.19082.62.camel@nimitz>
In-Reply-To: <1218242286.19082.62.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Fri, 2008-08-08 at 19:04 -0400, Oren Laadan wrote:
>>> struct pt_regs is part of the kernel ABI, it will not change.
>> I'm in favor about keeping the format identical between the variations of
>> each architecture. Note, however, that "struct pt_regs" won't do because it
>> may change with these variations.
> 
> "Part of the kernel ABI" makes it sound to me like it won't change.
> Who's right here? :)
 >
 > -- Dave
 >

hehehe .. both; I meant that while it doesn't change per architecture, it
varies between architectures. So "struct pt_regs" compiled for x86-32 is
different than that compiled for x86-64. Therefore we can't just dump the
structure as is and expect that 64 bit would be able to parse the 32 bit.
In other words, we need an intermediate representation.

Oren.
