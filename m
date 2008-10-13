Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYJMD72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYJMD72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 23:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYJMD7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 23:59:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47107
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbYJMD7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 23:59:19 -0400
Date: Sun, 12 Oct 2008 20:58:54 -0700 (PDT)
Message-Id: <20081012.205854.227501807.davem@davemloft.net>
To: petr@vandrovec.name
Cc: ivecera@redhat.com, romieu@fr.zoreil.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix NULL pointer dereference on r8169 load
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081012081352.GA29794@vana.vc.cvut.cz>
References: <20081012081352.GA29794@vana.vc.cvut.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Vandrovec <petr@vandrovec.name>
Date: Sun, 12 Oct 2008 10:13:52 +0200

> From: Petr Vandrovec <petr@vandrovec.name>
> 
> mmio_addr in r8169 needs to be initialized before use
> 
> Maybe that all tp-> initialization should be moved before rtl_init_mac_address call,
> but this is enough to get rid of crash in rtl_rar_set due to mmio_addr being uninitialized.
> 
> Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

Applied, thanks Petr.
