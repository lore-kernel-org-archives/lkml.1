Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbYCZM5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbYCZM5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYCZM5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:57:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60554 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbYCZM5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:57:39 -0400
Date: Wed, 26 Mar 2008 14:00:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080326130052.GF2170@one.firstfloor.org>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326102151.GB18965@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CONFIG_AGP=y
> CONFIG_AGP_AMD64=y
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_SIS is not set
> CONFIG_AGP_VIA=y
> CONFIG_DRM=y
> # CONFIG_DRM_TDFX is not set
> 
> ...do I need to enable something more?

Should have worked then. Ok modulo bugs. Maybe the ordering
is wrong now (AGP resume would need to run before anything
using the IOMMU)

-Andi
