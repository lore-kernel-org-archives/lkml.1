Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0CNTPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 15:15:22 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37041 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537Ab0CNTPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 15:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=pS2B9d6Sc7R4gm7iGfD/y8aLLrqv54VY6AMzbcC4PNDeCAAVw0fQ+KCVp0/41cGuBI
         lsvRRxys3gHFMZqGdHiu+rMpiK+xI29O+cs2szUc0WXn/v+/ZJwp/ua9+ax0IQJZk9/g
         4HSwPxroaVqvV9vMdJSFqw7TTKKLSg/jrcbZQ=
MIME-Version: 1.0
Date: Sun, 14 Mar 2010 23:15:18 +0400
Message-ID: <1a297b361003141215u70e608b3xb8fba358f3d9e802@mail.gmail.com>
Subject: PCI express switch handling ..
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Grant Grundler <grundler@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have one of these PCIe switches on one of the PCIe cards that I have:

http://www.plxtech.com/products/expresslane/pex8604

I was wondering how to handle this thing, ie;

I have to PCIe devices behind this switch, which looks thus:

06:00.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
07:01.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
07:04.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
07:05.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
09:00.0 Multimedia controller: Philips Semiconductors Device 7231 (rev aa)
0a:00.0 Multimedia controller: Philips Semiconductors Device 7231 (rev aa)

I am wondering if i need to access or address the switch specifically
to forward data specifically to one of the bridges behind the switch.
At present I can access one of the Multimedia controllers (09:00.0) ,
but it seems I can't access the other one and hence my question as to
determine whether it is something else.

Any pointer would be appreciated.

Thanks,
Manu
