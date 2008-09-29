Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYI2SPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYI2SPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbYI2SIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:08:55 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:54488 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839AbYI2SIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:08:54 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Date: Mon, 29 Sep 2008 21:08:31 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809292108.31659.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

What about: pci_iomap_bar(pdev, bar) that uses pci_iomap
(with the patch of Grant, http://lkml.org/lkml/2008/9/29/172)
and simplifies the arguments of pci_iomap() and makes all
the checks of the proposed by Arjan for ioremap_pcibar()?

Best of both worlds? ;-)
I like the simplification proposed by Arjan.

Regards.

Marin Mitov

P.S. I am not on the list.

