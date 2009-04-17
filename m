Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbZDQXDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbZDQXDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZDQXD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:03:27 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:7088 "EHLO
	stargate.chelsio.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752127AbZDQXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:03:26 -0400
X-Greylist: delayed 2497 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 19:03:26 EDT
Message-ID: <49E900D2.3040700@chelsio.com>
Date: Fri, 17 Apr 2009 15:21:06 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.30 0/4] cxgb3: driver fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2009 22:22:09.0828 (UTC) FILETIME=[F2F55640:01C9BFAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I am submitting a series of 4 patches for inclusion in 2.6.30.
Here is a brief description of the patch series:
- Use the existing periodic task to treat link faults, fix spin lock usage
- Fix missing workqueue flushes when the driver is unloaded
- Fix potential MSI-X vector leak on error case
- Fix EEH last recover attempt exit

Cheers,
Divy
