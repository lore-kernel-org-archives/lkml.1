Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbYEIQjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbYEIQjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbYEIQjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:39:41 -0400
Received: from mvp.visionpro.com ([63.91.95.2]:1667 "EHLO
	mvpexchange126.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761206AbYEIQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:39:40 -0400
X-Ninja-PIM: Scanned by Ninja
X-Ninja-AttachmentFiltering: (no action)
User-Agent: Microsoft-Entourage/12.1.0.080305
Date: Fri, 09 May 2008 09:27:34 -0700
Subject: Restricting Processor Usage
From: Brian McGrew <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C449C986.1E7ED%brian@visionpro.com>
Thread-Topic: Restricting Processor Usage
Thread-Index: Acix8ZXjBMpElKCw+Uiy9hWO2lvdrA==
Mime-version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that I've got sched_(set|get)affinity working (thank you all for all of
the great help), I need to figure out how to unload the processors in the
machine.

When the system comes up, by default the general system load is spread
across all the processors, even when it is idle.  I'm looking for a way to
force everything on the system (kernel, X, gnome, etc.) to run on only one
processor and leave the remaining processors idea for thread assignments.
I'm doing very heavy image processing and need all the power I can get out
of each CPU.

How can I do this?  Just make the system as a whole run on only one CPU but
allow processes and threads that I create to set their affinity to the
remaining unloaded CPU's???

-brian

