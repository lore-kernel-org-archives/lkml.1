Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZHJP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZHJP0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZHJP0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:26:20 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:47945 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZHJP0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:26:20 -0400
Date: Mon, 10 Aug 2009 17:26:06 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090810152606.GA23319@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A801D04.6050102@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
>>> Instead of using that we implemented a heretic IOCTL-based
>>> interface for user-space; at least with it you could create a
[ snip ]
>>> #define VME_IOCTL_START_DMA             _IOWR('V', 10, struct vme_dma)
>>>
> I am moving the interface in that direction, I remain unconvinced about  
> the contents of your vme_mapping structure, it's too tsi-148 specific.

Could you please point out why is too tsi148-specific?

The point here is that the driver should know *nothing* about
windows, etc. What it should just know is:
- I want a mapping of a certain size to VME address X
The struct provides exactly this.

Also, could you please send me (off-list) documentation of the
Universe bridge? It'd be useful for the work on the generic layer.

E.
