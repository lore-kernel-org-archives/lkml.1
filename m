Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbYKEJ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbYKEJ7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYKEJ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:59:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45953
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbYKEJ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:59:03 -0500
Date: Wed, 05 Nov 2008 01:58:38 -0800 (PST)
Message-Id: <20081105.015838.25391202.davem@davemloft.net>
To: mchan@broadcom.com
Cc: dada1@cosmosbay.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] linux-2.6.28-rc3 regression: IRQ smp_affinities not
 respected
From: David Miller <davem@davemloft.net>
In-Reply-To: <C27F8246C663564A84BB7AB343977242151F4B18B5@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <49113E31.8080106@cosmosbay.com>
	<C27F8246C663564A84BB7AB343977242151F4B18B5@IRVEXCHCCR01.corp.ad.broadcom.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Tue, 4 Nov 2008 22:45:43 -0800

> I believe this may be the patch that broke it:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd
> 
> I don't remember all the details, but the Broadcom 5708 chip is
> affected because it does not support MSI per-vector masking.
> 
> One way to get around is to disable MSI with bnx2 parameter
> disable_msi=1.

On first glance my reaction is that I think that patch should be
reverted, given what the tradeoff appears to be.

