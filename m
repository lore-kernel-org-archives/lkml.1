Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbZHKTLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbZHKTLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZHKTLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:11:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47052 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844AbZHKTK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:10:59 -0400
Date: Tue, 11 Aug 2009 20:12:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to disable DMA for compact-flash disk?
Message-ID: <20090811201206.14556624@lxorguk.ukuu.org.uk>
In-Reply-To: <4A81BDA6.4080804@candelatech.com>
References: <4A81BDA6.4080804@candelatech.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 11:51:18 -0700
Ben Greear <greearb@candelatech.com> wrote:

> I'm trying to use Fedora 11 with default kernel on an old via system
> that boots from compact flash.  DMA is not supported on the CF for
> whatever reason, and in previous kernels, I've always disabled
> DMA, first with ide=nodma, and then later with
> ide_core.nodma=0.0 ide_core.nodma=0.1 ...

Fedora switched to libata some releases ago so

libata.dma=n

0 - off
1 - disk only

+ 2 disk/CD
+ 4 disk/CD/CFA

(so you can turn DMA off just for CFA devices providing they admit they
are CFA)

