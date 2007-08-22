Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbXHVDql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbXHVDql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXHVDqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:46:31 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:32472 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbXHVDqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:46:30 -0400
Message-ID: <46CBB140.7060501@chelsio.com>
Date: Tue, 21 Aug 2007 20:45:04 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/11] cxgb3 - driver updates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Aug 2007 03:45:05.0849 (UTC) FILETIME=[D40CC290:01C7E46E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

I'm resubmitting the last cxgb3 patch series against netdev-2.6#upstream,
minus the first patch that you already applied and the last patch.

Here is a brief description:
-       Modify max HW Rx coalescing size
-       Log SGE doorbell Fifo overflow
-       Use Tx immediate data for offload packets whenever possible
-       RDMA can get internal mem info to workaround HW issues
-       More validity checks on connection ids
-       Stop MAC when a fatal error is detected
-       Log HW serial number
-       Update internal mem operating mode
-       Update engine microcode management, version is now 1.1.0
-       Update FW management, version is now 4.6.0
-       Ignore some HW errors until the HW is initialized

Cheers,
Divy



