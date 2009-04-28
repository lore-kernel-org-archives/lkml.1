Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbZD1BhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbZD1BhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZD1BhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:37:06 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:48360 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbZD1BhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:37:05 -0400
Message-ID: <49F65DBA.2090702@ovro.caltech.edu>
Date: Mon, 27 Apr 2009 18:36:58 -0700
From: David Hawkins <dwh@ovro.caltech.edu>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Liu Dave-R63238 <DaveLiu@freescale.com>
CC: Tabi Timur-B04825 <timur@freescale.com>, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <D7CCA83BB0796C49BC0BB53B6AB1208928CAB2@zch01exm21.fsl.freescale.net>
In-Reply-To: <D7CCA83BB0796C49BC0BB53B6AB1208928CAB2@zch01exm21.fsl.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Apr 2009 18:37:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> How about FIFO RAM case?

If the FIFO has a fixed address, then according to
the user guide, the DMA controller won't generate
a burst transaction to it.

We can try confirming this if you'd like.

Cheers,
Dave




