Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbXIMJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbXIMJtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbXIMJtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:49:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:48838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbXIMJtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:49:07 -0400
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
Date: Thu, 13 Sep 2007 11:47:42 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Martin Mares <mj@ucw.cz>,
       dean gaudet <dean@arctic.org>, Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200709121921.43950.yinghai.lu@sun.com>
In-Reply-To: <200709121921.43950.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131147.43446.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 04:21, Yinghai Lu wrote:
> [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used.
>
> reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.

I just rejected a similar patch -- this should be done using MMCONFIG

-Andi
