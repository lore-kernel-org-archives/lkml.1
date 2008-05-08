Return-Path: <linux-kernel-owner+w=401wt.eu-S1764561AbYEHP1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764561AbYEHP1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760161AbYEHP0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:26:53 -0400
Received: from mvp.visionpro.com ([63.91.95.2]:2041 "EHLO
	mvpexchange126.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759456AbYEHP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:26:50 -0400
X-Ninja-PIM: Scanned by Ninja
X-Ninja-AttachmentFiltering: (no action)
User-Agent: Microsoft-Entourage/12.1.0.080305
Date: Thu, 08 May 2008 08:15:43 -0700
Subject: Two questions about scheduling and threading.
From: Brian McGrew <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C448672F.1E24B%brian@visionpro.com>
Thread-Topic: Two questions about scheduling and threading.
Thread-Index: AcixFtMmQt1ggaBWdkGKfkPkh4HsWgAB47E2
In-Reply-To: <C4485A81.1E1EF%brian@visionpro.com>
Mime-version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're using the 2.6.16.16 kernel in an almost real time, multi processor and
multi threaded environment.

When I start my system for the first time, I start one thread for each
processor/core in the machine (is this the correct thing to do)?  These
threads set a busy flag, go to work and then go to sleep.  I put everything
to sleep as opposed to killing the threads because it saves me on average of
about 400ms each time around.

My problem is, and, it is very reproducable, that if CPU0 is at 100%, none
of my threads see the wakeup!  It doesn't matter what the other CPU's are
doing, if they're all at 0 or 100%, but if CPU0 is 100, I'm toast.  Is there
anyway around this?

Also, I know that we're supposed to sit back and let the scheduler do all
the work for us; but, in the 2.6.16.16 kernel, is there a way to assign a
specific thread and/or process to a designated processor???  I really need
to be able to do this because even with the preemptive scheduling, I'm still
real-time and it's not quite real-time enough!

Thanks!

-brian

