Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbXKBSx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbXKBSx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbXKBSxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:53:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52202 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbXKBSxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:53:19 -0400
Date: Fri, 2 Nov 2007 13:50:33 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       trevor.highland@gmail.com, mhalcrow@us.ibm.com
Subject: [PATCH 0/3] eCryptfs: extent offset fix, crypto performance, and larger header regions
Message-ID: <20071102185033.GB30487@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set includes some minor fixes for eCryptfs, including:

 - An enhancement to allow larger header regions

 - A bugfix for hosts with page size >4K

 - An enhancement to reduce crypto overhead

I recommend merging at least the bugfix into 2.6.24.
