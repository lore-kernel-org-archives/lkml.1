Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbYKNIPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbYKNIPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYKNIPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:15:43 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46701 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbYKNIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:15:42 -0500
X-Sasl-enc: ViZCjLB1MAdQ0dk0MHHzrqOQ+LyCoN62QxvUbK8fOlLi 1226650541
Message-ID: <491D33B9.5030308@ladisch.de>
Date: Fri, 14 Nov 2008 09:15:53 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
CC: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       alsa-devel@alsa-project.org, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] 2.6.26.[6|7]-rt11, alsa rawmidi, seq hang (tasklet_hi_schedule?)
References: <1226019485.3135.31.camel@localhost.localdomain>	<49140683.9040008@ladisch.de>	<1226610075.23485.20.camel@localhost.localdomain>	<1226616962.23485.28.camel@localhost.localdomain> <1226621569.23485.44.camel@localhost.localdomain>
In-Reply-To: <1226621569.23485.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Lopez-Lezcano wrote:
> I've been trying to follow the printk crumbs without much success.
> AFAICT it all points to tasklet_hi_schedule ...

I don't have -rt, but if the error is similar to the old one you might
try replacing tasklet_hi_schedule with tasklet_schedule.


HTH
Clemens
