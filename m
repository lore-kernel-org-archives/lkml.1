Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXI3Iu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXI3Iu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 04:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXI3IuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 04:50:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbXI3IuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 04:50:17 -0400
Date: Sun, 30 Sep 2007 01:50:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2
Message-Id: <20070930015014.78bb88d3.akpm@linux-foundation.org>
In-Reply-To: <18268.1191119181@turing-police.cc.vt.edu>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	<18268.1191119181@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 22:26:21 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Thu, 27 Sep 2007 02:22:20 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> 
> Locks up hard at very early boot on my Dell Latitude - grub says loading
> kernel, the screen clears, and we lock up before we get penguins.
> 
> -rc8-mm1 was OK. I'm off to go bisect, figured I'd drop a heads-up.
> 

It doesn't ring a bell, sorry.  hpet-force-enable-on-ich34.patch is known
to be bad, but it causes failure later in the boot than that.
