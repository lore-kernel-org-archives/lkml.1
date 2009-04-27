Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbZD0T4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbZD0T4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbZD0T4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:56:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:39125 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbZD0T4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:56:38 -0400
Cc: Timur Tabi <timur@freescale.com>, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       Ira Snyder <iws@ovro.caltech.edu>
Message-Id: <46B638E2-885C-4281-81EA-CB685264E143@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Hawkins <dwh@ovro.caltech.edu>
In-Reply-To: <49F60BF8.8040404@ovro.caltech.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
Date: Mon, 27 Apr 2009 14:54:22 -0500
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>	<49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F60BF8.8040404@ovro.caltech.edu>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27, 2009, at 2:48 PM, David Hawkins wrote:

> Can you give me an example of non-PCI memory that would be
> non-prefetchable that you'd like us to try? We can see if our
> host CPUs have an area like that ... we just need to know
> what device to look for first :)

You can mark the pci inbound window on the 83xx as non-prefetchable  
(assuming 83xx is host). On a x86 host I doubt there is any easy way  
to get non-prefetchable memory.

- k
