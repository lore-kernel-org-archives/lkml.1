Return-Path: <linux-kernel-owner+w=401wt.eu-S935601AbYEVKGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935601AbYEVKGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758963AbYEVKGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:06:39 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:38715 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586AbYEVKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:06:38 -0400
Message-ID: <48354469.40100@miraclelinux.com>
Date: Thu, 22 May 2008 19:01:13 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>
Subject: [RFC][PATCH 0/2 v2] MAZE: Introduction
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.5.22.24453
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

MAZE provides a mechanism for detecting excessive CPU cycle usage of
selected processes and sending signals to them.

The definition of excessive CPU cycle usage is staying in TASK_RUNNINT
state for a long time.
Normally, a working process doesn't stay long time in TASK_RUNNING state
because of occasional IO waits or calling sleeps.
MAZE detects excessive CPU cycle usage from process's information and sends
signal when time of staying in TASK_RUNNING exceeds user defined limits.

The aim is to implement a CGL (Carrier Grade Linux) requirement (AVL.14.0).

Quote from CGL specification: (http://developer.osdl.org/dev/cgl/cgl40/cgl40-availability.pdf)

OSDL CGL specifies that carrier grade Linux shall provide a
mechanism that detects excessive CPU cycle usage by any process or thread.
To enable detection, the following capabilities shall be provided:
 - Communication between the monitoring process and the kernel.
 - Registering a list of processes or threads and their allowed CPU cycle
   thresholds.
 - Ability to define policy based on process events including process/thread
   creation and exit.
 - Ability to take action whenever an event occurs.
 - Ability to set the CPU cycle threshold to a resolution of one millisecond.

Please review and tell me what you think.

Thanks.
Hirofumi Nakagawa


