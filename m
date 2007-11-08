Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbXKHGNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbXKHGNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXKHGNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:13:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:55315 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbXKHGM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:12:59 -0500
Message-ID: <4732A8E5.6090307@qumranet.com>
Date: Thu, 08 Nov 2007 08:12:53 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11944900163817-git-send-email-aliguori@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 08 Nov 2007 08:12:53 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> This is a PCI device that implements a transport for virtio.  It allows virtio
> devices to be used by QEMU based VMMs like KVM or Xen.
>
>   

Didn't see support for dma. I think that with Amit's pvdma patches you
can support dma-capable devices as well without too much fuss.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

