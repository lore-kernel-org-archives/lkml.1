Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbYFMPzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbYFMPzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 11:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYFMPze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 11:55:34 -0400
Received: from [194.117.236.238] ([194.117.236.238]:49613 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYFMPze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:55:34 -0400
Date: Fri, 13 Jun 2008 18:54:14 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: tzanussi@gmail.com, akpm@linux-foundation.org, compudj@krystal.dyndns.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
Message-ID: <20080613185414.306b4baa@linux360.ro>
In-Reply-To: <48521C19.6070001@cs.helsinki.fi>
References: <20080613041013.274ccb28@linux360.ro>
	<48521C19.6070001@cs.helsinki.fi>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 10:04:57 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Why do we need to change for_each_online_cpu to for_each_present_cpu?
> I guess it's because we don't have all the CPUs online at early
> boot?

Yes, that's true. Only one CPU is online at that early point.

> Wouldn't it then be better to implement CPU hotplug support
> instead?

It's difficult for me to write such code, as I'm unable to test CPU
hotplug; my machines are a Turion X2 laptop and a Athlon Barton desktop
computer. So I can't turn off, or unplug in a software sense, one CPU core.
Correct me if I'm wrong, but I don't see any way to do that in /sys/devices/system/cpu/

But I suppose I could write a patch very carefully, and then submit to
someone that can test this. Anyway, I'll look into this and try to
understand the code without being able to test.


	Eduard
