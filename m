Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbXEaMgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbXEaMgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761489AbXEaMfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:35:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42877 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761304AbXEaMfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:35:50 -0400
Message-ID: <465EC101.7010105@garzik.org>
Date: Thu, 31 May 2007 08:35:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       SCSI development list <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: 2.6.22-rc3-mm1
References: <20070530235823.793f00d9.akpm@linux-foundation.org>	<20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>	<20070531121557.GQ23968@parisc-linux.org> <20070531142048.05edf133@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070531142048.05edf133@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Thu, 31 May 2007 06:15:57 -0600,
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
>> On Thu, May 31, 2007 at 02:09:22PM +0200, Cornelia Huck wrote:
>>> I split those functions out into a new file. Builds on s390 and i386.
>> Why not just put #ifdef CONFIG_HAS_DMA / #endif around the pair of
>> functions?  I don't see the need to add a new Kconfig symbol and a new
>> file for this.
> 
> I prefer a new file over #ifdefs in c files. (New dma-dependent stuff
> would also have a place where it could go to.)
> 
> But I'll do whatever ends up as consensus :)

50 lines isn't much need for a new file.

	Jeff



