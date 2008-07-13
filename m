Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYGMLFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYGMLFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 07:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYGMLEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 07:04:54 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:57207 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbYGMLEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 07:04:54 -0400
Date: Sun, 13 Jul 2008 13:02:22 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alex Samad <alex@samad.com.au>
Cc: linux-kernel@vger.kernel.org, Edward Hsu <edward_hsu@realtek.com.tw>
Subject: Re: Page swap allocation failure 2.6.25
Message-ID: <20080713110222.GA16817@electric-eye.fr.zoreil.com>
References: <20080713093047.GB661@samad.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080713093047.GB661@samad.com.au>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Samad <alex@samad.com.au> :
[...]
> For a while now I have been receiving page swap allocation failures
> 
> 
> Similar to http://lkml.org/lkml/2008/6/10/3 and

Order 0 failure. Your is an order 2 one.

> http://lkml.org/lkml/2008/2/19/298

Order 3 failure which was fixed with the e1000e driver.

> and I have filed a bug with debian (Bug#486300)
> 
> 
> It seems like any time I put the system under load, transferring large
> files across the network  (1G nic, a r8186 and forcedeth and a
> broadcom).  I keep getting these errors

May I assume that you are working with a MTU greater than 1500 bytes on
each interface ? If so plese add netdev@vger.kernel.org to the Cc: and
remove linux-kernel@ from the Cc:.

[...]
> Jul 13 13:28:30 nas kernel: [  648.120756]  [<ffffffff881b525f>]
> :r8168:rtl8168_rx_fill+0x64/0x106

It looks more like Realtek's out-of-tree driver than like the in-kernel
one. Is it a customised kernel ?

[...]
> Help

Don't panic.

-- 
Ueimor
