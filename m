Return-Path: <linux-kernel-owner+w=401wt.eu-S1030712AbXAZCvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030712AbXAZCvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030714AbXAZCvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:51:48 -0500
Received: from verein.lst.de ([213.95.11.210]:54039 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030712AbXAZCvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:51:48 -0500
Date: Fri, 26 Jan 2007 03:50:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>, hch@infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, openfabrics-ewg@openib.org,
       raisch@de.ibm.com
Subject: Re: [PATCH 2.6.21 1/4] ehca: fix improper use of yield with spinlock held
Message-ID: <20070126025049.GB18537@lst.de>
References: <200701240010.37540.hnguyen@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701240010.37540.hnguyen@linux.vnet.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.6 () BAYES_01
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 12:10:36AM +0100, Hoang-Nam Nguyen wrote:
> Here is a patch for ehca_cq.c that fixes improper use of yield
> with spinlock held.

Btw, please don't forget to replace the yield call with a proper
condition for 2.6.21.

