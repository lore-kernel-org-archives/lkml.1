Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbXEOQmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbXEOQmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759048AbXEOQlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:41:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33916 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758688AbXEOQlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:41:50 -0400
Date: Tue, 15 May 2007 17:45:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasily Averin <vvs@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: [patch i2o 5/6] i2o_proc files permission
Message-ID: <20070515174533.1caf24bb@the-village.bc.nu>
In-Reply-To: <4649ABC9.6020605@sw.ru>
References: <4649AA6C.2080808@sw.ru>
	<4649ABC9.6020605@sw.ru>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 16:47:05 +0400
Vasily Averin <vvs@sw.ru> wrote:

> Reading from some i2o related proc files can lead to the i2o controller hang due
> unknown reasons. As a workaround this patch changes the permission of these
> files to root-only accessible.

I guess you have a crap controller in this case. 

This isn't the right fix: Detect your specific buggy control and do not
register the problem /proc nodes for it at all.

Alan
