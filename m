Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXBMQDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXBMQDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXBMQDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:03:39 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:59349 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbXBMQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:03:38 -0500
Subject: Re: current git crashes on bootup with pci_iounmap()
From: Marcel Holtmann <marcel@holtmann.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1171380714.3829.6.camel@pim.off.vrfy.org>
References: <1171380714.3829.6.camel@pim.off.vrfy.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 17:04:05 +0100
Message-Id: <1171382645.23580.29.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

> kernel BUG at lib/iomap.c:254!
> invalid opcode: 0000 [#1]
> ...
> 
> The screen picture is here:
>   http://vrfy.org/pci_iounmap.jpg
> 
> It's a Thinkpad T43p.
> 
> 2.6.20 was working fine.
> 
> Commenting out:
>   IO_COND(addr, /* nothing */, iounmap(addr));
> in:
>   lib/iomap.c:254
> makes at least booting up possible.

I saw a similar one on my X41. Disabling the AHCI driver made the
machine booting again.

Regards

Marcel


