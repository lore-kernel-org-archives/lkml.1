Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbZGTPwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbZGTPwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZGTPwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:52:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36883 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZGTPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:52:34 -0400
Date: Mon, 20 Jul 2009 16:52:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       Christoph Hellwig <hch@infradead.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRM drivers with closed source user-space: WAS  [Patch 0/3]
	Resubmit VIA Chrome9 DRM via_chrome9 for upstream
Message-ID: <20090720155226.GA27885@srcf.ucam.org>
References: <4A647358.1040009@shipmail.org> <20090720135844.GA16844@infradead.org> <4A648718.9000709@shipmail.org> <20090720161620.7b027f8d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720161620.7b027f8d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 04:16:20PM +0100, Alan Cox wrote:
> > If the common agreement of the linux community is to *NOT* allow these 
> > drivers in, so be it, then be honest and go ahead and tell the driver 
> > writers. Don't make them respin their development trying to fix minor 
> > flaws when their driver won't get in anyway!
> 
> The existing policy based on what has been rejected is:
> 
> - If you have something which only works with some non-free tightly
>   integrated software then we don't accept it
> 
> 	Examples - GMX500, Intel wireless regulatory daemon.

I think "tightly integrated" could do with some clarification here. 
qcserial was accepted despite not being functional without a closed 
userspace component - an open one's since been rewritten to allow it to 
work. Do we define "tightly integrated" as "likely to cross the GPL 
line" (potentially the case with Poulsbo, not the case with qcserial), 
or is it a pragmatic issue? What about specialised hardware drivers that 
only have closed applications?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
