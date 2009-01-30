Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZA3OQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZA3OQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZA3OPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:15:53 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45298 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZA3OPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:15:52 -0500
Date: Fri, 30 Jan 2009 15:15:51 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
In-Reply-To: <1233302349.17301.27.camel@localhost>
Message-ID: <alpine.LSU.2.00.0901301515150.29805@fbirervta.pbzchgretzou.qr>
References: <1233294584.28741.2.camel@localhost>  <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>  <1233297635.17301.11.camel@localhost>  <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr> <1233302349.17301.27.camel@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-01-30 08:59, Nathanael Hoyle wrote:
>> >Is there currently a standardized userspace tool to use to run a command
>> >in order to alter its scheduling class? Obviously writing one would be
>> >trivial, but didn't know if something like:
>> 
>> man chrt
>
>The latest version of man chrt that I can find implies that it handles
>SCHED_BATCH but not SCHED_IDLE. To that end, if anyone else is
>interested, I have thrown together the above-suggested 'runidle' which
>will invoke the passed command using the SCHED_IDLE scheduler; it's
>nothing fancy.

Should have added -i to chrt instead and submit ;-)
