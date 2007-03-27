Return-Path: <linux-kernel-owner+w=401wt.eu-S933909AbXC0BYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbXC0BYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933920AbXC0BYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:24:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57187
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933909AbXC0BYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:24:24 -0400
Date: Mon, 26 Mar 2007 18:24:22 -0700 (PDT)
Message-Id: <20070326.182422.115910859.davem@davemloft.net>
To: bunk@stusta.de
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC: 2.6.21 patch] let PCI_MSI depend on EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070327010247.GW16477@stusta.de>
References: <20070327010247.GW16477@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Tue, 27 Mar 2007 03:02:47 +0200

> We had during the last months have quite a few MSI bugs and even 
> regressions due to:
> - core kernel bugs,
> - device driver bugs and
> - hardware bugs
> 
> OTOH, MSI doesn't bring any real advantages for most users.
> 
> Let's therefore mark PCI_MSI as EXPERIMENTAL.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

This is a good way to ensure that the code doesn't get tested
enough to ever fix the problems.
