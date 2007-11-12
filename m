Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbXKLUjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbXKLUjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 15:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXKLUjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:39:41 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40443 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXKLUjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:39:40 -0500
Subject: x86 32-bit machine check handler
From: Max Asbock <masbock@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Content-Type: text/plain
Date: Mon, 12 Nov 2007 12:39:35 -0800
Message-Id: <1194899975.9979.7.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the 32-bit and 64-bit x86 machine check handlers live next to
each other a certain asymmetry in functionality is apparent. Notably,
the 64-bit machine check handler implements a timer that periodically
polls for silent machine check errors and makes them accessible to user
space through /dev/mcelog. Are there reasons the x86 32-bit machine
check handler couldn't do the same?

thanks,
Max  


