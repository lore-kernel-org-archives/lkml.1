Return-Path: <linux-kernel-owner+w=401wt.eu-S1760376AbXJMFpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376AbXJMFpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 01:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXJMFp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 01:45:28 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:34603 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbXJMFp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 01:45:27 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 01:45:27 EDT
Message-ID: <47105A39.9070406@debian.org>
Date: Sat, 13 Oct 2007 07:40:09 +0200
From: Giacomo Catenazzi <cate@debian.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.git build error
References: <1192164538.10413.3.camel@Homer.simpson.net>	 <20071012213114.GA24016@uranus.ravnborg.org> <1192246457.7395.19.camel@Homer.simpson.net>
In-Reply-To: <1192246457.7395.19.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Fri, 2007-10-12 at 23:31 +0200, Sam Ravnborg wrote:
>> On Fri, Oct 12, 2007 at 06:48:58AM +0200, Mike Galbraith wrote:
>>> Greetings,
>>>
>>> Freshly pulled 2.6.23.git failed to build:
>>>
>>> make[1]: *** No rule to make target `arch/x86/kernel/asm-offsets.c', needed by `arch/x86/kernel/asm-offsets.s'.  Stop.
>>> make: *** [prepare0] Error 2
>>> make: *** Waiting for unfinished jobs....
>> You are the only reporter of this bug.
>> I do not see it here and I have the asm-offset.c file.
> 
> Yeah, I noticed nobody else was griping.


I also saw this behaiour, but make mrproper solved the problem.


ciao
	cate
