Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZAOJMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZAOJMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760449AbZAOJLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:11:34 -0500
Received: from mail.openmoko.org ([88.198.124.205]:53102 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbZAOJLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:11:31 -0500
Date: Thu, 15 Jan 2009 14:41:08 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_MFD_PCF50633=m breaks the kernel build
Message-ID: <20090115091107.GB3199@fedora.yogi>
References: <20090115100653.509416fb@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115100653.509416fb@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 10:06:53AM +0100, Jean Delvare wrote:
> Hi Balaji,
> 
> Building kernel 2.6.29-rc1-git4 on x86_64 with CONFIG_MFD_PCF50633=m
> fails at linking time with:
> 
> ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!

Yes, I've seen this. The fix is waiting on linux-mfd to be pulled
anytime soon.

Thanks,
Balaji
