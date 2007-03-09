Return-Path: <linux-kernel-owner+w=401wt.eu-S1161200AbXCHXjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161200AbXCHXjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161221AbXCHXjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:39:16 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60988 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161200AbXCHXjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:39:14 -0500
Date: Fri, 9 Mar 2007 00:43:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
Message-ID: <20070309004303.721f8b50@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Surely that's racy when two threads write to the same fd and the first
> vfs_write call blocks or is preempted.  Or does fget_light take some
> per-file lock that I'm not seeing?

I think you are making assumptions about file position behaviour that are
simply not guaranteed in the standards document.
