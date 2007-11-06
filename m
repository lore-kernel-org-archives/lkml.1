Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbXKFN2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbXKFN2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXKFN2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:28:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49141
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbXKFN2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:28:24 -0500
Date: Tue, 06 Nov 2007 05:28:23 -0800 (PST)
Message-Id: <20071106.052823.160483403.davem@davemloft.net>
To: adobriyan@sw.ru
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH -net 2/2] Put proc_net_create() on death row
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071106122350.GB6215@localhost.sw.ru>
References: <20071106122350.GB6215@localhost.sw.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@sw.ru>
Date: Tue, 6 Nov 2007 15:23:50 +0300

> proc_net_create() stands on the way of shrinking the number of
> interfaces one can use for /proc files, namely, it uses ->get_info
> hook which will be converted, deprecated and deleted on its own
> schedule.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Applied.
