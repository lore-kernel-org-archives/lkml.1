Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZAMSaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZAMSaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZAMSaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:30:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZAMSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:30:00 -0500
Message-ID: <496CDDA2.8080206@zytor.com>
Date: Tue, 13 Jan 2009 10:29:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matias <linux@sundmangroup.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Intel x86 Dual Core & Linux AMP
References: <496C8A98.90309@sundmangroup.com>
In-Reply-To: <496C8A98.90309@sundmangroup.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matias wrote:
> Is there a way to boot a normal standard home x86 dual core PC with two
> different Linux Kernels without a hypervisor?
> The idea is of course to give the Kernels their own address space and
> their own rootfile systems, the devices would be unique for each kernel
> etc.
> 
> Can this be done with a standard BIOS and GRUB/LILO?

No.  There are way too many shared resources, such as address space and
interrupt system.  You need a central resource to arbitrate those
resources, i.e. a hypervisor.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

