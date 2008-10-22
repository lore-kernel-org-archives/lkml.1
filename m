Return-Path: <linux-kernel-owner+w=401wt.eu-S1751424AbYJVE5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbYJVE5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYJVE5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:57:42 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62860 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYJVE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:57:40 -0400
Date: Tue, 21 Oct 2008 21:57:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21 (printk format warnings)
Message-Id: <20081021215725.b9c2b941.randy.dunlap@oracle.com>
In-Reply-To: <20081021195109.ed83b102.sfr@canb.auug.org.au>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 19:51:09 +1100 Stephen Rothwell wrote:


printk format warnings summary:

i386:

linux-next-20081021/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'

linux-next-20081021/drivers/misc/intel_menlow.c:107: warning: format '%ld' expects type 'long int', but argument 3 has type 'long long unsigned int'

x86_64:

linux-next-20081021/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'

linux-next-20081021/drivers/usb/misc/vstusb.c:623: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

linux-next-20081021/drivers/misc/intel_menlow.c:107: warning: format '%ld' expects type 'long int', but argument 3 has type 'long long unsigned int'



Other arches not built, but a few of them are really good at finding this
sort of problem...

---
~Randy
