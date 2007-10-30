Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbXJ3EDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbXJ3EDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXJ3ED2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:03:28 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:45219 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbXJ3ED1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:03:27 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 30 Oct 2007 15:03:15 +1100
X-Spam-Score: 0.001
X-CSE-Spam-Checker-Version: SpamAssassin 3.1.3 (2006-06-01) on 
	tone.orchestra.cse.unsw.EDU.AU
X-CSE-Spam-Level: 
X-CSE-Spam-Status: No, score=-2.6 required=4.0 tests=BAYES_00,UNPARSEABLE_RELAY 
	autolearn=ham version=3.1.3
Message-ID: <4726AD03.2080908@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: [PATCH 0/3] Deadline iosched: Fix batching algorithm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

The following patches correct some issues with the deadline I/O
scheduler and its batching algorithm.

Patch 1 is a simple function factorisation.
Patch 2 fixes a missing batch count reset, making the behaviour
  closer to that implied by the documentation.
Patch 3 changes batch start points to resolve a disparity in
  latency and bandwidth between high- and low-sector requests.


Thanks,
-- Aaron


