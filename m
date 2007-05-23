Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbXEWKeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbXEWKeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbXEWKeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:34:11 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54038 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbXEWKeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:34:09 -0400
Date: Wed, 23 May 2007 16:11:22 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Shaya Potter <spotter@cs.columbia.edu>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 10/14] In-kernel file copy between union mounted filesystems
Message-ID: <20070523104122.GF3338@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094329.GL4139@in.ibm.com> <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr> <20070518111042.GC4869@in.ibm.com> <464DAE73.7000302@cs.columbia.edu> <20070522031327.GA4728@in.ibm.com> <Pine.LNX.4.61.0705220824320.4452@yvahk01.tjqt.qr> <20070522083826.GD4728@in.ibm.com> <4652E385.30803@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4652E385.30803@cs.columbia.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 08:35:17AM -0400, Shaya Potter wrote:
> Bharata B Rao wrote:
> >
> >In case of regular files, when we copyup a file, we are actually preventing
> >any writes to the lower layers (which we have designated as read only).
> >
> >Applying the same logic to devices, what do we achieve by copying them up ?
> >How does it matter if we write to the device through a node in the upper
> >layer or in the lower layer. Both the writes eventually do the same thing.
> 
> What happens if the lower layer is on a read only medium.  But the top 
> layer is RW.  Why can't one change permissions?  In your model, one can't.
> 
> What happens if one wants to share a lower layer read-only (I'm doing 
> this with my research into uses of union file systems), one doesn't want 
> permission change in one use of the lower layer to affect any of the 
> other uses.

Ok, makes sense. Thanks for the clarification.

So looks like in addition to copyup on open (which is what we do currently)
there is a case for doing copyups for other situations also.

Regards,
Bharata.
