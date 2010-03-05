Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0CEIdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 03:33:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:42630 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754456Ab0CEIdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 03:33:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/5GJN1j4b5FBGAEYFo5xzr404r7/awX4M8Gqiufd
	i+YenmH3Fu20hV
Subject: Re: sched_fair: the schedule check condition?
From: Mike Galbraith <efault@gmx.de>
To: figo zhang <figo1802@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <c6ed1ac51003042356y5ccb42f1va550747b9e72129e@mail.gmail.com>
References: <c6ed1ac51003042356y5ccb42f1va550747b9e72129e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 05 Mar 2010 09:33:51 +0100
Message-Id: <1267778031.9309.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 15:56 +0800, figo zhang wrote:
> hi,
> 
> in check_preempt_tick() funtion, the check schedule condition the
> reality increasing runtime "delta_exec"
> and vruntime increasing "delta", and reality ideal time "ideal_runtime":
> 
>             if (delta_exec > ideal_runtime)
> and
>             if (delta > ideal_runtime)
> 
> if equal,  it should be need schedule?

Moving the border 1 ns just doesn't matter given the huge pile of ns on
either side of that border.

	-Mike

