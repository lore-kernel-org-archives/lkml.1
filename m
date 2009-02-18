Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZBRQth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZBRQth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZBRQt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:49:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:45524 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbZBRQt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:49:26 -0500
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Arnd Bergmann <arnd@arndb.de>, Jan-Bernd Themann <THEMANN@de.ibm.com>,
       netdev@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <D999D051-E5A2-4915-893D-E3384EC312A4@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Ira Snyder <iws@ovro.caltech.edu>
In-Reply-To: <20090217222425.GA18801@ovro.caltech.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [RFC v1] virtio: add virtio-over-PCI driver
Date: Wed, 18 Feb 2009 10:47:05 -0600
References: <20090217222425.GA18801@ovro.caltech.edu>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 17, 2009, at 4:24 PM, Ira Snyder wrote:

>
> Documentation/virtio-over-PCI.txt     |   61 ++
> arch/powerpc/boot/dts/mpc834x_mds.dts |    7 +

we'll have to review the .dts and expect a documentation update for  
the node.  But that's pretty minor at this point.

> drivers/virtio/Kconfig                |   22 +
> drivers/virtio/Makefile               |    2 +
> drivers/virtio/vop.h                  |  119 ++
> drivers/virtio/vop_fsl.c              | 1911 ++++++++++++++++++++++++ 
> +++++++++

make this vop_fsl_mpc83xx.c or something along those lines.

>
> drivers/virtio/vop_host.c             | 1028 ++++++++++++++++++
> drivers/virtio/vop_hw.h               |   80 ++
> 8 files changed, 3230 insertions(+), 0 deletions(-)
> create mode 100644 Documentation/virtio-over-PCI.txt
> create mode 100644 drivers/virtio/vop.h
> create mode 100644 drivers/virtio/vop_fsl.c
> create mode 100644 drivers/virtio/vop_host.c
> create mode 100644 drivers/virtio/vop_hw.h

- k
