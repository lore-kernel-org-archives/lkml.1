Return-Path: <linux-kernel-owner+w=401wt.eu-S1751034AbXAYL2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbXAYL2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 06:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXAYL2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 06:28:49 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:53250 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbXAYL2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 06:28:48 -0500
Subject: Re: [patch] suspend/resume debugging: device filter
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Linus Torvalds <torvalds@osdl.org>,
       Greg KH <gregkh@suse.de>
In-Reply-To: <20070125110501.GA25151@elte.hu>
References: <20070125110501.GA25151@elte.hu>
Content-Type: text/plain
Date: Thu, 25 Jan 2007 22:28:46 +1100
Message-Id: <1169724526.1316.8.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2007-01-25 at 12:05 +0100, Ingo Molnar wrote:
> it might be better to do this centrally in sysfs, via a per-device 
> attribute, to individually enable suspend and resume on a per device 
> basis, but my sysfs-fu is not strong enough for that now ;-)

Yeah. I was thinking recently of doing a per-device attribute, but like
so many things at the moment, getting around to it is a little bit of a
problem.

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/base/power/resume.c  |    6 ++++
>  drivers/base/power/suspend.c |    3 +-
>  include/linux/resume-trace.h |    6 ++++
>  kernel/power/main.c          |   58 +++++++++++++++++++++++++++++++++++++++++++

Should the sysfs stuff (not just this) be in kernel/power/main.c? I
wonder if it would be better put in drivers/base?

Regards,

Nigel

