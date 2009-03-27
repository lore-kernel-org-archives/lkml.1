Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbZC0T37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbZC0T37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZC0T3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:29:50 -0400
Received: from [213.79.90.228] ([213.79.90.228]:58605 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753166AbZC0T3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:29:50 -0400
Date: Fri, 27 Mar 2009 22:29:47 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: cbou@mail.ru,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Using POWER or APM for battery handling
Message-ID: <20090327192947.GA13609@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090327202406.60885d4a.kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090327202406.60885d4a.kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kristoffer,

On Fri, Mar 27, 2009 at 08:24:06PM +0100, Kristoffer Ericson wrote:
> Hey Anton,
> 
> My machines (HP Jornada 600-series and HP Jornada 700-series) both
> rely on batteries for power. Now, in the past it has all
> been handled by an APM_EMULATION driver that
> essentially detects the current state (loading YES/NO, 
> POWER_LEFT, ESTIMATED TIME LEFT,...) and adjusts
> the state of the machine.
> 
> My question is should I port this to instead
> use the power class (drivers/power) or not.

The driver is already there:
drivers/power/apm_power.c

So all you need is Jornada driver for the power supply class,
and then apm_power.c will work for your battery driver.

Feel free to ask if there is anything still not clear.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
