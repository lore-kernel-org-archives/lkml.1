Return-Path: <linux-kernel-owner+w=401wt.eu-S936429AbXJQD7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936429AbXJQD7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934461AbXJQD7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:59:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36245
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760997AbXJQD7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:59:33 -0400
Date: Tue, 16 Oct 2007 20:59:39 -0700 (PDT)
Message-Id: <20071016.205939.41651938.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: akepner@sgi.com, tony.luck@intel.com, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dma: redefine dma_flags_set/get_*() for sn-ia64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071016202904.8e9d505b.akpm@linux-foundation.org>
References: <20071017014316.GK5601@sgi.com>
	<20071016202904.8e9d505b.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 16 Oct 2007 20:29:04 -0700

> So we take an `enum data_direction' and then wedge it into a word alongside
> some extra flags?
> 
> Can we do something nicer than that?

Yes, I discussed this last time around, this type abuse stinks and
it's confusing.
