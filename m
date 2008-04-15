Return-Path: <linux-kernel-owner+w=401wt.eu-S1765525AbYDOQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765525AbYDOQjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYDOQjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:39:11 -0400
Received: from ns.fe.uni-lj.si ([212.235.181.2]:40974 "EHLO ns.fe.uni-lj.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYDOQjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:39:10 -0400
X-Greylist: delayed 2051 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2008 12:39:10 EDT
Message-ID: <4804D228.3090406@fe.uni-lj.si>
Date: Tue, 15 Apr 2008 18:04:56 +0200
From: Janez Pers <janez.pers@fe.uni-lj.si>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: shmat/shmdt penalty
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2008 16:09:08.0660 (UTC) FILETIME=[0923DF40:01C89F13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Is there significant penalty for doing shmat/shmdt to a preexisting/
pre-created shared memory segment 60-200 times a second in multiple
processes using a modern (2.6) linux kernel on i386 architecture?

Specifically, do I risk:

* significant slowdown due to context switching (e.g. more than 10%)?
* memory fragmentation (?)
* any other resource exhaustion if such code runs for hours?
* scorn and laughter by people who read my code?

Sorry if this is faq or documented anywhere (I could not find it) - then
the pointer/url to the relevant literature will be enough.

Regards,

Janez.
