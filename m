Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZBERo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZBERo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZBERoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:44:20 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:56310 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbZBERoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:44:19 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 12:44:19 EST
Message-ID: <498B23A5.6090006@f-seidel.de>
Date: Thu, 05 Feb 2009 18:36:37 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Frank Seidel <fseidel@suse.de>
CC: Greg KH <greg@kroah.com>, linux kernel <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       kristen.c.accardi@intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] PCI: add missing KERN_* constants to printks
References: <498B2116.6010707@suse.de> <20090205172859.GA20558@kroah.com> <498B2294.5010809@suse.de>
In-Reply-To: <498B2294.5010809@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Seidel wrote:
> No, its definition in pciehp.h is:
> ...

P.S.: I also thought about changing it directly inside
the macro. Would you prefer that?
I decided against that because those printk-macros often
still use the loglevel prefix and i didn't want to change
semantics of the macro (eventhough one would of course
suspect it to set KERN_DEBUG).

Thanks,
Frank
