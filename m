Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZIVTKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZIVTKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZIVTKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:10:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:43833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZIVTKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:10:49 -0400
Date: Tue, 22 Sep 2009 21:11:01 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: gabe@blackfam.net
Cc: gabebblack@gmail.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: TI PCIe-PCI bridge quirks
Message-ID: <20090922211101.076e9763@infradead.org>
In-Reply-To: <8a15eb2b0909221201k70b9e9darc6fda53f87bfae29@mail.gmail.com>
References: <8a15eb2b0909221201k70b9e9darc6fda53f87bfae29@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 14:01:06 -0500
Gabe Black <gabebblack@gmail.com> wrote:

> Hi,
> 
> The TI XIO2000A/XIO2200A PCIe-PCI bridge (VID: 104C, DID: 8231)
> erroneously handles fast back-to-back transfers on its subordinate bus
> segment.  The behavior is seen when there are multiple devices
> downstream and transfers from both devices result in a fast b2b
> transfer.  This confuses the PCIe-PCI bridge and results in data
> corruption.
> 
> One way to work around the buggy bridge would be to disable fast b2b
> transfers on any device on the subordinate bus-segment by writing the
> appropriate bits in the device's pci-configspace command register.
> 
> Are there any suggestions on how this might be handled?  Should this
> be addressed in the kernel?

sounds like this is worth a PCI quirk in the kernel...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
