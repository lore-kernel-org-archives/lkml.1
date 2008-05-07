Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbYEGVNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYEGVNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYEGVNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:13:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:56846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbYEGVNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:13:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,450,1204531200"; 
   d="scan'208";a="278958315"
Subject: [regression?] distcc says: (dcc_pump_sendfile) ERROR: sendfile
	returned 0? can't cope (bisected)
From: Dan Williams <dan.j.williams@intel.com>
To: Tom Zanussi <zanussi@comcast.net>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 May 2008 14:13:31 -0700
Message-Id: <1210194811.16427.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
X-OriginalArrivalTime: 07 May 2008 21:13:32.0808 (UTC) FILETIME=[34823080:01C8B087]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom, Jens,

My build system started reporting these error messages recently.
Reverting commit c3270e577c18b3d0e984c3371493205a4807db9d on top of
2.6.26-rc1 gets things working for me again.

--
Dan
