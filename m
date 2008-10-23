Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYJWSTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYJWSTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbYJWSSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:18:54 -0400
Received: from verein.lst.de ([213.95.11.210]:40424 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152AbYJWSSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:18:53 -0400
Date: Thu, 23 Oct 2008 20:18:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-kernel@vger.kernel.org
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Roland McGrath <roland@redhat.com>
Subject: wierd new config options
Message-ID: <20081023181818.GA25430@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is UNEVICTABLE_LRU and option?  Is there any rason to turn it off or
is this just to confuse users?

CORE_DUMP_DEFAULT_ELF_HEADERS is similarly odd, it turns something on
that break old userspace, this really really should be a sysctl to turn
on instead of a config option.
