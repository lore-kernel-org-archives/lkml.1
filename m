Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbXLVULR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbXLVULR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXLVULG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:11:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49559 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXLVULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:11:05 -0500
Date: Sat, 22 Dec 2007 12:09:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Bloch <matthew@bytemark.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071222120959.475ebced@laptopd505.fenrus.org>
In-Reply-To: <fk8umh$n7o$1@ger.gmane.org>
References: <fk8umh$n7o$1@ger.gmane.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 17:06:24 +0000
Matthew Bloch <matthew@bytemark.co.uk> wrote:

> Hi - I'm trying to come up with a way of thoroughly testing every byte
> of RAM from within Linux on amd64 (so that it can be automated better
> than using memtest86+), and came up with an idea which I'm not sure is
> supported or practical.
> 
> The obvious problem with testing memory from user space is that you
> can't mlock all of it, so the best you can do is about three quarters,
> and hope that the rest of the memory is okay.

well... to be honest the more obvious problem will be that you won't be testing the RAM, you'll be testing the CPU's cache.. over and over again.

memtest86+ does various magic to basically bypass the caches (by disabling them ;-)...
Doing that in a live kernel situation, and from userspace to boot...... that's... and issue.
