Return-Path: <linux-kernel-owner+w=401wt.eu-S2992843AbXDDLMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992843AbXDDLMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992850AbXDDLMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:12:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33435 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992843AbXDDLME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:12:04 -0400
Date: Wed, 4 Apr 2007 12:14:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, flar@allandria.com, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404121434.73d01e7e@the-village.bc.nu>
In-Reply-To: <20070403.185026.26966290.davem@davemloft.net>
References: <20070404022828.5c9b97f3@the-village.bc.nu>
	<Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
	<20070404024400.56d016e1@the-village.bc.nu>
	<20070403.185026.26966290.davem@davemloft.net>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you want hierarchy, create it:
> 
> /sys/blah/serial/controllerX/portY
> 
> and keeping them all under the ttyS? major keeps the simple
> cases working sanely too.

Currently yes you could do that, but that would break all the back
compatibility.
