Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab0CKNPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:15:30 -0500
Received: from toro.web-alm.net ([62.245.132.31]:51515 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab0CKNP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:15:27 -0500
X-Greylist: delayed 2706 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 08:15:26 EST
Message-Id: <20100311122454.585724424@osadl.org>
User-Agent: quilt/0.47-1
Date: Thu, 11 Mar 2010 13:24:54 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/1] tracing: Fix erroneous task states in sched_switch event
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent change in the task state definitions was omitted to apply to the
sched_switch event output.

In addition, move task state definitions to a common place. This ensures that
future changes make it to all places where needed.

        Carsten. 

