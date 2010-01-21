Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399Ab0AUVyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0AUVyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828Ab0AUVyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:54:40 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:28207 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab0AUVyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:54:39 -0500
Date: Thu, 21 Jan 2010 14:54:38 -0700
From: Alex Chiang <achiang@hp.com>
To: Luca Zini <luca.zini@gmail.com>
Cc: aagaande@gmail.com, rdelcueto@hotmail.com, efault@gmx.de, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel <linux-kernel@vger.kernel.org>
Subject: scheduler vs hardware? (was Re: another i7  (linux) bug?)
Message-ID: <20100121215438.GK17684@ldl.fc.hp.com>
References: <201001211258.23499.luca.zini@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001211258.23499.luca.zini@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scheduler folks cc'ed.

* Luca Zini <luca.zini@gmail.com>:
> Dear all, 
> I find your addresses in the thread 
> (http://bugzilla.kernel.org/show_bug.cgi?id=15064) that I followed.

In general, it's better to send mail to the mailing lists in case
individual developers don't have time/expertise to help you.

Which kernel are you using?

This may be an issue for the scheduler folks since in your
experiment, the only thing you're changing are the nice levels,
not hardware.

> I had the same problem that now seems to be solved. There is
> also another peculiarity in my system:
>
> if I run a cpu intensive process with the lowest priority (19
> from man nice) I obtain much better performance that with the
> highest priority available (-20 from man nice).
>
> For example the same file is processed by lame in 8.7 seconds
> at the lowest priority, and in 12 seconds at the highest
> priority.  Before posting a bug I wold like to understand if
> this is a problem related to the i7 mobile (my processor is a
> i7 Q720).
> 
> As far as I tested on the same laptop series (dell studio 15),
> with the same kernel this problem does not exists.
> 
> Can you test your i7 mobile system to help me to understand if
> it is related to the processor?
> 
> Regards, Luca Zini
> 
