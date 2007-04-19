Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXDSOas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXDSOas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbXDSOas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:30:48 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:38286 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXDSOar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:30:47 -0400
Date: Thu, 19 Apr 2007 16:30:07 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Bart Trojanowski <bart@jukie.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to tell linux (on x86) to ignore 1M or memory
Message-ID: <20070419163007.26db4041@localhost>
In-Reply-To: <20070419141804.GO32620@jukie.net>
References: <20070419141804.GO32620@jukie.net>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 10:18:04 -0400
Bart Trojanowski <bart@jukie.net> wrote:

> I need to preserve some state from the bios before entering protected
> mode.  For now I want to copy it into some ram accessible by real-mode,
> say the last megabyte visible in real-mode.
> 
> What's the easiest way to have linux ignore the megabyte starting at 15M?
> 

Documentation/kernel-parameters.txt:

        memmap=nn[KMG]$ss[KMG]
                        [KNL,ACPI] Mark specific memory as reserved.
                        Region of memory to be used, from ss to ss+nn.


So adding this to kernel boot parameters should do the trick:

	memmap=15M$1M

-- 
	Paolo Ornati
	Linux 2.6.21-rc7-CFS-v3-g6262cd9f on x86_64
