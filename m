Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbXGONHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbXGONHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 09:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXGONHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 09:07:47 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:58380 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbXGONHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 09:07:46 -0400
To: oleg@tv-sign.ru
CC: rjw@sisk.pl, pavel@ucw.cz, linux-kernel@vger.kernel.org
In-reply-to: <20070714212102.GA214@tv-sign.ru> (message from Oleg Nesterov on
	Sun, 15 Jul 2007 01:21:02 +0400)
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
References: <20070714212102.GA214@tv-sign.ru>
Message-Id: <E1IA3oR-0002wg-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 15 Jul 2007 15:06:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > SIGKILL won't work on a stopped task.  Neither on a traced task.
> 
> Why do you think so? It works in both cases (ptracer can use
> PT_TRACE_EXIT, but the task is killed anyway).

Just from experience with tasks stuck in "T" state.  After for example
an UML dies, some of the processes only react to SIGCONT, but not to
SIGKILL.

I have no idea why this happens.

Miklos
