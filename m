Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZESOlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZESOlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZESOlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:41:19 -0400
Received: from ozlabs.org ([203.10.76.45]:53638 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZESOlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:41:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] virtio_blk: add missing __dev{init,exit} markings
Date: Wed, 20 May 2009 00:10:51 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       jbarnes@virtuousgeek.org, virtualization@lists.linux-foundation.org
References: <1242632349-15894-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1242632349-15894-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905200010.51786.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 05:09:09 pm Mike Frysinger wrote:
> -static int virtblk_probe(struct virtio_device *vdev)
> +static int __devinit virtblk_probe(struct virtio_device *vdev)

This makes sense, I think, but then it implies that virtio_dev_probe() should 
also be __devinit, right?

And I look at pci_bus_probe(), and it's not __devinit.

Is the PCI code just slack?
Rusty.
