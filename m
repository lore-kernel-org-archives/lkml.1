Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbXELHyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbXELHyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXELHxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:53:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51206 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbXELHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:53:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4645725F.3060809@s5r6.in-berlin.de>
Date: Sat, 12 May 2007 09:53:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Satyam Sharma <satyam.sharma@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net>	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>	 <464551D5.2050709@zytor.com>	 <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>	 <46455CD9.7010205@zytor.com> <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com> <4645691C.5090408@zytor.com>
In-Reply-To: <4645691C.5090408@zytor.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
[slightly off topic: GCCisms in Linux kernel]
> It contains *many* constructs that are not defined in, for
> example, C99, and it would in fact be impossible to write the Linux
> kernel using only C99-compliant constructs.

True.  On the other hand, it is possible to keep large parts of the
kernel independent of compiler implementation details.  And it is not
only possible but also beneficial, e.g. because the compiler's
implementation changes over time.
-- 
Stefan Richter
-=====-=-=== -=-= -==--
http://arcgraph.de/sr/
