Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZFRCDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZFRCDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZFRCDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:03:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50541
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562AbZFRCDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:03:34 -0400
Date: Wed, 17 Jun 2009 19:03:38 -0700 (PDT)
Message-Id: <20090617.190338.69331786.davem@davemloft.net>
To: rjw@sisk.pl
Cc: jeffrey.t.kirsher@intel.com, andi@lisas.de, akpm@linux-foundation.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Net / e100: Fix suspend of devices that cannot be
 power managed
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906142146.47639.rjw@sisk.pl>
References: <200906141606.29754.rjw@sisk.pl>
	<20090614164604.GA19746@rhlx01.hs-esslingen.de>
	<200906142146.47639.rjw@sisk.pl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 14 Jun 2009 21:46:46 +0200

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If the adapter is not power-manageable using either ACPI, or the
> native PCI PM interface, __e100_power_off() returns error code, which
> causes every attempt to suspend to fail, although it should return 0
> in such a case.  Fix this problem by ignoring the return value of
> pci_set_power_state() in __e100_power_off().
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Andreas Mohr <andi@lisas.de>

Applied, thanks!
