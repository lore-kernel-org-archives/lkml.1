Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbXESQLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbXESQLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXESQLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:11:23 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:38183 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbXESQLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:11:23 -0400
In-Reply-To: <023132a5c5a4f07ec2d46b0515a55d4b@kernel.crashing.org>
References: <200705190953.l4J9rjO2024613@harpo.it.uu.se> <023132a5c5a4f07ec2d46b0515a55d4b@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <e3e772afd2f56253d20d5332499cd7ff@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       lkml Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: gcc-4.2.0 breakage on powerpc?
Date: Sat, 19 May 2007 18:11:20 +0200
To: Segher Boessenkool <segher@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> and we'll end up
>>>> having major kernel releases which don't build on i386 with major 
>>>> gcc
>>>> releases, which isn't altogether desirable.
>>>
>>> Yeah, like 4.2.0 with powerpc.  Seems like no one tested it :-(
>>
>> Details please. What exactly are the gcc-4.2.0 problems on powerpc?
>
> http://gcc.gnu.org/PR31490 .  Most stuff using named
> sections won't build; that includes CONFIG_MODULES.
> There is no viable workaround.  The problem is being
> handled.  I'll post a patch for the kernel refusing
> to build with this combination soon.

[Cc:ing the PowerPC list]

Oh btw, most likely this is a problem on 64-bit only.


Segher

