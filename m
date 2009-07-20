Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbZGTP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbZGTP5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZGTP5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:57:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZGTP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:57:53 -0400
Date: Mon, 20 Jul 2009 11:57:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Hellstr?m <thomas@shipmail.org>,
       Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090720155745.GB12536@infradead.org>
References: <4A647358.1040009@shipmail.org> <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org> <20090720161620.7b027f8d@lxorguk.ukuu.org.uk> <20090720155226.GA27885@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720155226.GA27885@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 04:52:26PM +0100, Matthew Garrett wrote:
> I think "tightly integrated" could do with some clarification here. 
> qcserial was accepted despite not being functional without a closed 
> userspace component - an open one's since been rewritten to allow it to 
> work. Do we define "tightly integrated" as "likely to cross the GPL 
> line" (potentially the case with Poulsbo, not the case with qcserial), 
> or is it a pragmatic issue? What about specialised hardware drivers that 
> only have closed applications?

Greg still claims that qcserial could be used by rebooting from Windows,
right?  In that it would still be extremly borderline to me, but it's
settled now.  We also have various SCSI HBA drivers that can be used
just fine, but contain tons ot ioctls for management tools that aren't
available as open source (or even easily obtainable at all).  Personally
I don't think we should merge those unless we have userspace code
available freely, but it's a less urgent issue than merging drivers that
can't be used at all.  The DRM modules fall to me exactly into that
category for "specialised hardware drivers that only have closed
applications", and the answer to those should be a clear no.

