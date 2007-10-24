Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbXJXNiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbXJXNiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbXJXNiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:38:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19348 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758027AbXJXNiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:38:08 -0400
Date: Wed, 24 Oct 2007 15:38:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Olivier Galibert <galibert@pobox.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071024133804.GB14671@kernel.dk>
References: <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk> <471DC3D9.2070809@panasas.com> <20071023095507.GE5059@kernel.dk> <471DCBB2.9020706@panasas.com> <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org> <20071024080549.GZ14671@kernel.dk> <Pine.LNX.4.64.0710241103000.5840@anakin> <20071024091242.GK14671@kernel.dk> <20071024133553.GA39386@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024133553.GA39386@dspnet.fr.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Olivier Galibert wrote:
> On Wed, Oct 24, 2007 at 11:12:42AM +0200, Jens Axboe wrote:
> > sg_set_buf() also sets length and offset, sg_set_page() is just a mirror
> > of that. So I'd prefer to keep the naming.
> 
> Hmmm, sg_set_phys/sg_set_virt to be more symmetrical to
> sg_phys/sg_virt?

(please don't drop cc lists)

That doesn't make any sense. Both sg_set_buf() and sg_set_page() set the
same thing in the sg entry, the input is just different. It has nothing
to do with setting the physical value, for instance.

-- 
Jens Axboe

