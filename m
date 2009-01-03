Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbZACPHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbZACPHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 10:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbZACPHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 10:07:40 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:51178 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZACPHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:07:38 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jan 2009 10:07:38 EST
X-Auth-Info: 7Ws2pG8f7fNJWVlzuGTGv48T77bcg16jssEUj6ivT6k=
X-Auth-Info: 7Ws2pG8f7fNJWVlzuGTGv48T77bcg16jssEUj6ivT6k=
X-Auth-Info: 7Ws2pG8f7fNJWVlzuGTGv48T77bcg16jssEUj6ivT6k=
X-Auth-Info: 7Ws2pG8f7fNJWVlzuGTGv48T77bcg16jssEUj6ivT6k=
X-Auth-Info: 7Ws2pG8f7fNJWVlzuGTGv48T77bcg16jssEUj6ivT6k=
X-Auth-Info: 7Ws2pG8f7fNJWVlzuGTGv48T77bcg16jssEUj6ivT6k=
X-Auth-Info: 7Ws2pG8f7fNJWVlzuGTGv48T77bcg16jssEUj6ivT6k=
To: Paul Mundt <lethal@linux-sh.org>
cc: Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
From: Wolfgang Denk <wd@denx.de>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <20090102095023.GA28078@linux-sh.org>
References: <200901020207.30359.rob@landley.net> <20090102095023.GA28078@linux-sh.org>
Comments: In-reply-to Paul Mundt <lethal@linux-sh.org>
   message dated "Fri, 02 Jan 2009 18:50:23 +0900."
Date: Sat, 03 Jan 2009 15:59:24 +0100
Message-Id: <20090103145924.BE7968387CDB@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Paul Mundt,

In message <20090102095023.GA28078@linux-sh.org> you wrote:
>
> Your main reasons against inclusion of perl seem to be that there is no
> realistic expectation for target systems that will be self-hosting will
> have perl included, or the inherent complexity in maintaining a coherent
> cross compiling environment. Both of these things are issues with your
> own environment, and in no way are these representative of the embedded
> development community at large.

I'm  not  sure  how  representative  for  the  "embedded  development
community at large" your statement is.

Just to add a data point to the statistice, I do agree with Rob's
opinion about needing Per to build the Linux kernel.

All other arguments aside, natively compiling the Linux kernel  on  a
target  board, especially with root file system mounted over NFS, has
always been an excellent stress test (you may even call it regression
test) for Linux running on some target hardware.

Losing this ability just because  some  scripts  are  implemented  in
language  FOO when plain shell will do as well is something we should
try to avoid.

Of course, YMMV.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Include the success of others in your dreams for your own success.
