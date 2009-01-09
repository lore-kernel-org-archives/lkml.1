Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZAISRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZAISRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZAISRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:17:21 -0500
Received: from rtr.ca ([76.10.145.34]:41372 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZAISRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:17:19 -0500
Message-ID: <496794AD.6040403@rtr.ca>
Date: Fri, 09 Jan 2009 13:17:17 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/6] fastboot: make scsi probes asynchronous
References: <20090105200959.04a626ac@infradead.org> <20090105201118.5bfa1e36@infradead.org>
In-Reply-To: <20090105201118.5bfa1e36@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>From 19617cfb1840abc69cc2fe74433007fc1daa1cb7 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 4 Jan 2009 05:32:28 -0800
> Subject: [PATCH] fastboot: make scsi probes asynchronous
> 
> This patch makes part of the scsi probe (which is mostly device spin up and the
> partition scan) asynchronous. Only the part that runs after getting the device
> number allocated is asynchronous, ensuring that device numbering remains stable.
..

Will this burn up the PSUs in loaded server boxes,
due to all drives spinning-up simultaneously now?

Just curious.
