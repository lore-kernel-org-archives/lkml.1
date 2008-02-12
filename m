Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbYBLKgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbYBLKgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbYBLKgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:36:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56385 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYBLKgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:36:05 -0500
Date: Tue, 12 Feb 2008 19:35:22 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [5/8] Fix logic error in 64bit memory hotadd
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
In-Reply-To: <200802111405.04423.ak@suse.de>
References: <20080211124625.GB23733@elte.hu> <200802111405.04423.ak@suse.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080212190310.F9E8.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo-san.

> > Does anyone even  
> > use memory hotplug currently? 
> 
> I don't know.

IBM's powerpc box can memory hot-add/remove by dynamic partitioning.
And our fujitsu server has memory hot-add feature (Ia-64).
So, they are concrete user of memory hotplug.

In x86, E8500 chipset has the feature of memory-hotplug.
(I searched a data-sheet from intel site.)
http://download.intel.com/design/chipsets/e8500/datashts/30674501.pdf
(6.3.8 IMI Hot-Plug)

So, it depends on how many server uses it, I think.

Thanks.

-- 
Yasunori Goto 


