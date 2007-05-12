Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbXELLwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbXELLwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXELLwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:52:40 -0400
Received: from zakalwe.fi ([80.83.5.154]:60190 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbXELLwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:52:39 -0400
Date: Sat, 12 May 2007 14:51:51 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Satyam Sharma <satyam.sharma@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       jimmy bahuleyan <knight.camelot@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 3
Message-ID: <20070512115151.GB10873@zakalwe.fi>
References: <12700.1178905000@lwn.net> <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com> <464551D5.2050709@zytor.com> <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com> <46455CD9.7010205@zytor.com> <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com> <4645691C.5090408@zytor.com> <4645725F.3060809@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4645725F.3060809@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 09:53:03AM +0200, Stefan Richter wrote:
> H. Peter Anvin wrote:
> [slightly off topic: GCCisms in Linux kernel]
> > It contains *many* constructs that are not defined in, for
> > example, C99, and it would in fact be impossible to write the Linux
> > kernel using only C99-compliant constructs.
> 
> True.  On the other hand, it is possible to keep large parts of the
> kernel independent of compiler implementation details.  And it is not
> only possible but also beneficial, e.g. because the compiler's
> implementation changes over time.

I think the most important reason for portable code is that new readers 
are more familiar with effects of the code.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
