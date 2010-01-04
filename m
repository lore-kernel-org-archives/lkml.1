Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026Ab0ADMhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0ADMhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524Ab0ADMhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:37:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58977 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0ADMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:37:19 -0500
Subject: Re: [RFC][PATCH] sched: avoid huge bonus to sleepers on busy
 machines
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Suresh Jayaraman <sjayaraman@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1262608250.9734.50.camel@marge.simson.net>
References: <1262596842-17392-1-git-send-email-sjayaraman@suse.de>
	 <1262603675.9734.36.camel@marge.simson.net>  <4B41D8E5.1000908@suse.de>
	 <1262608250.9734.50.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 13:36:37 +0100
Message-ID: <1262608597.6408.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 13:30 +0100, Mike Galbraith wrote:
> Any diddling of sleeper fairness would have to be accompanied with a
> preemption model change methinks. 

Just told jays the exact same thing on IRC ;-)

Also, workloads are interesting, the signal test thing is the easiest to
test the preemption side, various things like QPID show the down-side
iirc.

