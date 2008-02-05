Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYBESq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYBESq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbYBESqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:46:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45515 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYBESqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:46:44 -0500
Date: Tue, 5 Feb 2008 10:46:23 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: =?UTF-8?B?0JTQsNC80ZjQsNC9INCT0LXQvtGA0LPQuNC10LLRgdC60Lg=?= 
	<penguinista@mail.net.mk>
Cc: Shaohua Li <shaohua.li@intel.com>, Greg KH <greg@kroah.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: PCIE ASPM support hangs my laptop pretty often
Message-ID: <20080205104623.33c5f3e0@laptopd505.fenrus.org>
In-Reply-To: <200802051840.05237.penguinista@mail.net.mk>
References: <200802051840.05237.penguinista@mail.net.mk>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 18:40:04 +0100
Дамјан Георгиевски  <penguinista@mail.net.mk> wrote:

> I've patched my kernel with the PCIe ASPM and after setting
> echo powersave > /sys/module/pcie_aspm/parameters/policy
> 
> I started to experience random hangs of my laptop.
> Hardware info:
> Thinkpad x60s 1704-5UG

the x60's chipset doesn't support ASPM properly afaik... bad idea.
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
