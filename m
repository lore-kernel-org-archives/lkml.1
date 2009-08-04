Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbZHDHJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbZHDHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 03:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932476AbZHDHJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 03:09:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50509 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbZHDHJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:09:55 -0400
Subject: Re: [RFC patch] return early if all dmar HW unit ignored
From: David Woodhouse <dwmw2@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <3877989d0907310129p29dd5039p18563946b9be8099@mail.gmail.com>
References: <3877989d0907310129p29dd5039p18563946b9be8099@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 08:09:54 +0100
Message-Id: <1249369794.9324.18.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-31 at 16:29 +0800, Luming Yu wrote:
> Hello list,
> 
> When debugging an IOMMU problem, I noticed it should be much more safe
> to return early than late if all remapping HW unit are ignored.
> To figure out what device causes the iommu problem on my linux box:
> hp-compaq dc7800, I tried to mark all dmar HW
> unit ignored,but still got a lot of unxepcted dmar_fault. So I think
> the proposed patch make sense. The next step is to
> add a boot option to make dmar HW units selectable enable/disable individually.

Why were you seeing faults if all dmar units were ignored? Surely that
shouldn't happen?

This patch doesn't make a lot of sense on its own -- can you show what
you were intending to do as the 'next step'?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

