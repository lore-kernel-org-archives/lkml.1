Return-Path: <linux-kernel-owner+w=401wt.eu-S1032112AbXEHU6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032112AbXEHU6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031374AbXEHU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:58:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40666
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031224AbXEHU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:58:10 -0400
Date: Tue, 08 May 2007 13:58:10 -0700 (PDT)
Message-Id: <20070508.135810.48808124.davem@davemloft.net>
To: greg@kroah.com
Cc: cornelia.huck@de.ibm.com, torvalds@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070508140753.GB12641@kroah.com>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<20070508140753.GB12641@kroah.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Tue, 8 May 2007 07:07:53 -0700

> Only if it ends up working properly.  The commit you reference above
> (which removed the PCI_MULTITHREAD_PROBE option), is fine, pci
> multi-threaded probing is still broken as it is a model that PCI drivers
> are not yet ready to handle properly yet.

FWIW I would like to see this working properly at some point.

It seems to me that the issues are two-fold:

1) A proper dependency system is necessary

2) Proper mutual exclusion for shared system resources/registers/etc.
   that are poked at in an ad-hoc unlocked manner currently

Is that basically what it boils down to?
