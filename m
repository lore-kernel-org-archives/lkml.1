Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXBNQn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXBNQn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380AbXBNQn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:43:59 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:16756 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbXBNQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:43:59 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org
Subject: [PATCH 2.6.21-rc1 0/5] ehca patch set for 2.6.21-rc1
Date: Wed, 14 Feb 2007 17:40:30 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, h.carstens@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141740.30637.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland!
Here is a patch set for ehca with the following changes resp. bug fixes:
* Reworked irq handler to avoid/reduce missed irq events
* Fix race condition bug in find_next_online_cpu() and other potential
  locking issue of scaling code
* Allow scaling code to be configurable (en-/disable) via module parameter
* Replace yield() in ehca_destroy_cq() by wait_for_completion()
* ehca_query_port() now returns LINK_UP for phys_state instead UNKNOWN
Thanks!
Nam
