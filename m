Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506Ab0ABGP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0ABGP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 01:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362Ab0ABGP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 01:15:28 -0500
Received: from mx.binnacle.cx ([74.95.187.105]:41567 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0ABGP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 01:15:28 -0500
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jan 2010 01:15:28 EST
Message-Id: <6.2.5.6.2.20100102005433.03a07f40@flumedata.com>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Sat, 02 Jan 2010 01:01:05 -0500
To: linux-kernel@vger.kernel.org
From: starlight@binnacle.cx
Subject: suggestion:  msgctl(IPC_RMID) req CAP_IPC_OWNER instead
  of CAP_SYS_ADMIN
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have a service daemon that must on occasion clean up orphaned 
SVR4/POSIX message queues left over by dead client processes.

The service daemon runs with least privileges, and it receives a 
small set of capabilities that its job demands.

However I was surprised to see that CAP_SYS_ADMIN is needed when
using IPC_RMID to remove message queues owned by other user 
IDs.  This is a powerful and dangerous privilege and I dislike 
assigning it to the daemon.  Seems to me that CAP_IPC_OWNER is a 
better fit for this function.

This is just a suggestion.  Please respond with my e-mail CCed 
as I am not a list subscriber.

Regards

