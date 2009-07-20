Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZGTQC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZGTQC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZGTQCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:02:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47568 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZGTQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:02:25 -0400
Date: Mon, 20 Jul 2009 17:02:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Hellstr?m <thomas@shipmail.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090720160215.GB27885@srcf.ucam.org>
References: <4A647358.1040009@shipmail.org> <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org> <20090720161620.7b027f8d@lxorguk.ukuu.org.uk> <20090720155226.GA27885@srcf.ucam.org> <20090720155745.GB12536@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720155745.GB12536@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 11:57:45AM -0400, Christoph Hellwig wrote:

> Greg still claims that qcserial could be used by rebooting from Windows,
> right?

I think any argument that involves us requiring open userspace but 
allows us to get away with using Windows as a firmware loader is a 
dubious one :) But yes, it's certainly borderline. I'm not going to 
argue that it's clearly wrong, and I'm also aware that putting explicit 
limits on any of this is potentially an invitation for people to try to 
get as close to the line as they can.

> In that it would still be extremly borderline to me, but it's
> settled now.  We also have various SCSI HBA drivers that can be used
> just fine, but contain tons ot ioctls for management tools that aren't
> available as open source (or even easily obtainable at all).  Personally
> I don't think we should merge those unless we have userspace code
> available freely, but it's a less urgent issue than merging drivers that
> can't be used at all.  The DRM modules fall to me exactly into that
> category for "specialised hardware drivers that only have closed
> applications", and the answer to those should be a clear no.

I'd lean in the same direction.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
