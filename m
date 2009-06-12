Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbZFLHwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbZFLHwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759765AbZFLHwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:52:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34982 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757839AbZFLHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:52:22 -0400
Date: Fri, 12 Jun 2009 08:53:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Chapman <hchapman-linux-kernel@3gfp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Matching hard disks to BIOS boot order
Message-ID: <20090612085341.04ffcae2@lxorguk.ukuu.org.uk>
In-Reply-To: <4A31D8E8.4090200@3gfp.com>
References: <4A31D8E8.4090200@3gfp.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 00:26:16 -0400
Harvey Chapman <hchapman-linux-kernel@3gfp.com> wrote:

> Is there a way to figure out which hard disks match the BIOS boot order?
> 
> I'm trying to tell a Linux program which disk to use based on the disk 
> numbers (0,1,...) used by Windows. The best solution I've found so far 
> is disk serial number, but that hasn't been terribly reliable for other 
> reasons.

There is a BIOS interface for this on newer systems, although the kernel
doesn't capture enough data to make it completely reliable below EDD 3.0
(in theory if we grabbed a few more bits we could do EDD 1.x as well)

Most PCs today do EDD 3.0 however

