Return-Path: <linux-kernel-owner+w=401wt.eu-S1759162AbXESMwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbXESMwI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbXESMv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:51:57 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:41995 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967AbXESMv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:51:56 -0400
In-Reply-To: <200705190953.l4J9rjO2024613@harpo.it.uu.se>
References: <200705190953.l4J9rjO2024613@harpo.it.uu.se>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <023132a5c5a4f07ec2d46b0515a55d4b@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: gcc-4.2.0 breakage on powerpc?
Date: Sat, 19 May 2007 14:51:44 +0200
To: Mikael Pettersson <mikpe@it.uu.se>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> and we'll end up
>>> having major kernel releases which don't build on i386 with major gcc
>>> releases, which isn't altogether desirable.
>>
>> Yeah, like 4.2.0 with powerpc.  Seems like no one tested it :-(
>
> Details please. What exactly are the gcc-4.2.0 problems on powerpc?

http://gcc.gnu.org/PR31490 .  Most stuff using named
sections won't build; that includes CONFIG_MODULES.
There is no viable workaround.  The problem is being
handled.  I'll post a patch for the kernel refusing
to build with this combination soon.


Segher

