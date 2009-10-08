Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbZJHNpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbZJHNpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZJHNp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:45:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:41079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbZJHNp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:45:28 -0400
Date: Thu, 8 Oct 2009 06:45:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
Message-ID: <20091008064521.07fae137@infradead.org>
In-Reply-To: <1255001062.7500.1.camel@marge.simson.net>
References: <200910051500.55875.elendil@planet.nl>
	<200910061749.02805.elendil@planet.nl>
	<200910071910.53907.elendil@planet.nl>
	<200910072034.57511.elendil@planet.nl>
	<1255001062.7500.1.camel@marge.simson.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Oct 2009 13:24:22 +0200
Mike Galbraith <efault@gmx.de> wrote:
> Latencytop was accounting uninterruptible and interruptible sleep
> time up to 5ms, which is not the latency the user is looking for.

it is for everything but the scheduler latency!

latencytop wants to show where you're waiting for disk, etc etc.
that's not "time on runqueue".

for the scheduler delays a whole different codepath is used!




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
