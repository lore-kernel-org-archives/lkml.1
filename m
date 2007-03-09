Return-Path: <linux-kernel-owner+w=401wt.eu-S1767180AbXCILPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767180AbXCILPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767184AbXCILPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:15:50 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52741 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767180AbXCILPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:15:47 -0500
Date: Fri, 9 Mar 2007 12:19:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Amit Choudhary <amit2030@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/char/vt.c: check kmalloc() return value.
Message-ID: <20070309121959.11bd566c@lxorguk.ukuu.org.uk>
In-Reply-To: <20070308232713.ef9c608e.amit2030@gmail.com>
References: <20070308232713.ef9c608e.amit2030@gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007 23:27:13 -0800
Amit Choudhary <amit2030@gmail.com> wrote:

> Description: Check the return value of kmalloc() in function con_init(), in file drivers/char/vt.c.

NAK; This occurs at boot and if it fails we are wasting our time
recovering.

Alan
