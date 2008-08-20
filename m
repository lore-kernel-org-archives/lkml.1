Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYHTGpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYHTGpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 02:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYHTGpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 02:45:03 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:50510 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbYHTGpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 02:45:03 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2008 02:45:02 EDT
Date: Wed, 20 Aug 2008 00:38:20 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 0/0] Power domain and clock domain patches for omap
In-Reply-To: <g8feuo$i9$1@ger.gmane.org>
Message-ID: <alpine.DEB.1.00.0808200034010.26647@utopia.booyaka.com>
References: <1216221555-18958-1-git-send-email-tony@atomide.com> <g8feuo$i9$1@ger.gmane.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

On Tue, 19 Aug 2008, Dmitry Baryshkov wrote:

> There is one major flaw IMO in this code. Please correct me if I'm wrong:
> Driver A: powerdomain_register()
> Driver B: powerdomain_get()
> Driver A: powerdomain_unregister()
> 
> Then Driver B has a reference to unregistered domain. And as powerdomains
> lack any type of refcounting this can lead to any type of memory access
> bugs if Driver A is unloaded from the kernel.

At this point, only OMAP kernel init code registers powerdomains in 
arch/arm/mach-omap2/io.c.  It's not intended that driver code will 
manipulate or even know about these.

Thanks for the comments,

- Paul
