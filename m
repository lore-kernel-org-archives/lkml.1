Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZHJJOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZHJJOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZHJJOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:14:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbZHJJOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:14:01 -0400
Subject: Re: [RFC patch] return early if all dmar HW unit ignored
From: David Woodhouse <dwmw2@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <3877989d0908092321h56afcc7ve9fe39fa68f42a48@mail.gmail.com>
References: <3877989d0907310129p29dd5039p18563946b9be8099@mail.gmail.com>
	 <1249369794.9324.18.camel@macbook.infradead.org>
	 <3877989d0908092321h56afcc7ve9fe39fa68f42a48@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 10:13:59 +0100
Message-Id: <1249895639.4919.133.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 14:21 +0800, Luming Yu wrote:
> 
> But I don't know why I were seeing faults if all dmar units were
> ignored? Surely that shouldn't happen? Will double check and
> investigate.

It shouldn't happen -- I suspect that you didn't actually mark them
_all_ ignored? What happens if you modify my patch just to mark the
offending unit as ignored, but don't also apply your patch? Does it boot
then?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

