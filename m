Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbYCZV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbYCZV6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYCZV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:58:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45581 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755836AbYCZV6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:58:09 -0400
Date: Wed, 26 Mar 2008 16:58:07 -0500
From: Dean Nelson <dcn@sgi.com>
To: jes@sgi.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: [Patch 0/5] prepare XPC and XPNET to support SGI UV -v3
Message-ID: <20080326215807.GF31340@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of five patches moves XPC and XPNET to drivers/misc/xp in preparation
for enabling X86_64 support.

I discovered that the previous versions of this patch were missing the
replacement of kernel_thread() by kthread_run() and the elimination of
daemonize().

