Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbXH1GpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbXH1GpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXH1GpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:45:03 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52680 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbXH1GpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:45:01 -0400
Date: Tue, 28 Aug 2007 08:45:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Luka Napotnik <luka.napotnik@gmail.com>
cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: division and cpu usage
In-Reply-To: <46D34B19.6050006@gmail.com>
Message-ID: <Pine.LNX.4.64.0708280843030.11442@fbirervta.pbzchgretzou.qr>
References: <46CE1BA2.8070200@gmail.com> <Pine.LNX.4.61.0708240731130.8096@chaos.analogic.com>
 <Pine.LNX.4.64.0708241442590.28540@fbirervta.pbzchgretzou.qr>
 <46D34B19.6050006@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28 2007 00:07, Luka Napotnik wrote:
>>>> 2. I'm trying to get the percentage of CPU used for a certain
>>>> task_struct and figured the following formula:
>>>>
>>>> (task->utime + task->stime) / jiffies
>
>This formula just doesn't work. I have a task with 99% CPU (top) but the
>result of that formula is random (4, sometimes 8). What am I doing
>wrong? Please help.

You are calculating the CPU time the process has used since the start.
That is definitely not the same as the "%CPU" that top shows, more like
the "TIME+" top shows by default.

