Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbZAMGwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbZAMGwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZAMGwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:52:38 -0500
Received: from mail.openmoko.org ([88.198.124.205]:43942 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZAMGwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:52:37 -0500
Date: Tue, 13 Jan 2009 12:22:02 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: David Miller <davem@redhat.com>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       andy@openmoko.com, sameo@openedhand.com, mingo@elte.hu,
       yinghai@kernel.org, akpm@linux-foundation.org, sfr@canb.auug.org.au
Subject: Re: pcf50663 MFD driver modular build failure
Message-ID: <20090113065159.GB3218@fedora.yogi>
References: <20090112.210501.215941396.davem@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112.210501.215941396.davem@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 09:05:01PM -0800, David Miller wrote:
> 
> This started happening with Linus's pull from today for
> sparc64 allmodconfig:
> 
> ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> 
> Sure we can export __set_irq_handler() and handle_level_irq() to
> modules to fix this, but that looks like some hokey stuff for
> a MFD driver to be doing :-)

Yes, right! It's really not necessary. I've sent a patch to remove it.

Thanks,
Balaji
