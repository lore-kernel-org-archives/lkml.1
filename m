Return-Path: <linux-kernel-owner+w=401wt.eu-S1765230AbZLQRzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765230AbZLQRzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764867AbZLQRzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:55:50 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:35774 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbZLQRzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:55:49 -0500
Date: Thu, 17 Dec 2009 09:55:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-pci@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 17 (pci/quirks)
Message-Id: <20091217095506.64f0a43f.randy.dunlap@oracle.com>
In-Reply-To: <20091217165840.e11fc719.sfr@canb.auug.org.au>
References: <20091217165840.e11fc719.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4B2A70A1.018C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 16:58:40 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> My usual call for calm: please do not put stuff destined for 2.6.34 into
> linux-next trees until after 2.6.33-rc1.
> 
> Changes since 20091216:


When CONFIG_PCI_QUIRKS=n:

drivers/built-in.o: In function `pci_dev_reset':
pci.c:(.text+0xdb0b): undefined reference to `pci_dev_reset_methods'
pci.c:(.text+0xdb2b): undefined reference to `pci_dev_reset_methods'
pci.c:(.text+0xdb85): undefined reference to `pci_dev_reset_methods'


pci_dev_reset() calls (inlined) pci_dev_specific_reset(),
which references pci_dev_reset_methods, which does not exist.


---
~Randy
