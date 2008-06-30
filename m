Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbYF3Smz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbYF3Smz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYF3Smr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:42:47 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:50284 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751308AbYF3Smq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:42:46 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] PCI: add stub for pci_set_consistent_dma_mask()
Date: Mon, 30 Jun 2008 11:42:30 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       mb@bu3sch.de, jejb <James.Bottomley@hansenpartnership.com>,
       akpm <akpm@linux-foundation.org>
References: <20080630113553.c133307f.randy.dunlap@oracle.com>
In-Reply-To: <20080630113553.c133307f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301142.31124.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2008 11:35 am Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> When CONFIG_PCI=n, there is no stub for pci_set_consistent_dma_mask(),
> so add one like other similar stubs.  Otherwise there can be build errors,
> as here:
>
> linux-next-20080630/drivers/ssb/main.c:1175: error: implicit declaration of
> function 'pci_set_consistent_dma_mask'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied to linux-next, thanks Randy.

Jesse
