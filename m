Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbYJAGlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbYJAGlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYJAGlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:41:22 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:53932 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYJAGlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:41:22 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Date: Wed, 1 Oct 2008 09:39:04 +0300
User-Agent: KMail/1.9.9
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010939.04244.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry to interfere :-)

> I'm fine with pci_iomap_bar()... it meets my goals
> Would be nice if I'd be allowed to make it only work on MEM bars not IO
> bars (so that drivers don't accidentally end up calling this on an IO
> bar and then using readl() etc)

If have understood the APIs correctly, pci_iomap() is supposed to be used
in conjunction with io{read,write}{8,16,32}(), not with readl() etc.

Regards.

Marin Mitov

