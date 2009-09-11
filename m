Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZIKOOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZIKOOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZIKOOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:14:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbZIKOOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:14:01 -0400
From: Amit Shah <amit.shah@redhat.com>
To: rusty@rustcorp.com.au
Cc: alan@linux.intel.com, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Multiple ports support for virtio_console; major number for dev
Date: Fri, 11 Sep 2009 19:43:05 +0530
Message-Id: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

This is the patch that I have for adding support for multiple ports to
virtio_console. It's pretty stable in my testing so far and the memory
corruption that I had earlier has been resolved in linux-next so I'm
proposing this for inclusion.

This currently uses device major number 60 from the experimental range;
Alan could you please reserve a new major number for virtio_console?

Rusty, can you give this a review once more?

Thanks,
		Amit
