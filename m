Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZB1VLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZB1VLO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZB1VK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:10:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44455 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbZB1VK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:10:57 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A9A836.3070205@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 22:10:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902272046.50572.david-b@pacbell.net> <49A92487.3020108@s5r6.in-berlin.de> <200902281219.54200.david-b@pacbell.net>
In-Reply-To: <200902281219.54200.david-b@pacbell.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>> Why don't these drivers simply use <linux/workqueue.h>?
> 
> Most do.  In fact, that one *does* ... what's your point?

Workqueue jobs are rarely seen doing
#ifdef CONFIG_LOCKDEP
	local_irq_enable();
#endif

> If I hadn't know that more generic threaded IRQ support
> was already on the way, I might have done more with that
> particular driver than just massive cleanup.

OK, makes sense.
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
