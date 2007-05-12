Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbXELHWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbXELHWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbXELHW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:22:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50541 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbXELHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:22:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46456B18.9060605@s5r6.in-berlin.de>
Date: Sat, 12 May 2007 09:22:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net>	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>	 <464551D5.2050709@zytor.com>	 <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>	 <46455CD9.7010205@zytor.com> <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com>
In-Reply-To: <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Coming back to the document, we do need to document / find
> consensus on the "preferred" way to do similar business in the
> kernel, and my opinion as far as that is concerned is to shun
> volatile wherever possible (which includes the case originally
> discussed above).

I too recommend that volatile-considered-harmful.txt is not watered down
by an ever growing "but if" list.  If anybody knows what he does, he
still can program in a deviating way --- provided that he leaves a brief
comment in the code, telling why it is possible and beneficial to use
the volatile qualifier in this special case.
-- 
Stefan Richter
-=====-=-=== -=-= -==--
http://arcgraph.de/sr/
