Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYFEKJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYFEKJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYFEKJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 06:09:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYFEKJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 06:09:28 -0400
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200806051207.50556.arekm@pld-linux.org>
References: <20080605.foo@pmac.infradead.org>
	 <200806051207.50556.arekm@pld-linux.org>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 11:09:26 +0100
Message-Id: <1212660566.32207.179.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 12:07 +0200, Arkadiusz Miskiewicz wrote:
> On Thursday 05 June 2008, David Woodhouse wrote:
> > Ignoring the set of 'make fw->data const' patches which have mostly
> > been already posted and are fairly trivial, this is the current content
> > of the firmware tree at git.infradead.org/users/dwmw2/firmware-2.6.git
> >
> > It starts by giving a way to build arbitrary firmware blobs into the
> > kernel while letting request_firmware() find them there, and then sets
> > about converting drivers to use request_firmware() instead of static
> > data blobs, now that we can do that without forcing the users to
> > actually  satisfy the firmware requests from userspace.
> 
> Will there be a way for userspace to know what firmware file is needed by 
> which driver? 
> 
> So for example geninitrd/mkinitrd will be able to put only required firmware 
> files into initrd/initramfs (without a need to maintain separate database 
> with driver <-> firmware file name mapping).

We've had that for a long time: MODULE_FIRMWARE().

-- 
dwmw2

