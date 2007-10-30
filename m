Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbXJ3PLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbXJ3PLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbXJ3PLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:11:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41469 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbXJ3PLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:11:22 -0400
Date: Tue, 30 Oct 2007 09:11:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/dpt_i2o: Convert to generic boolean
Message-ID: <20071030151121.GM32359@parisc-linux.org>
References: <20071030104806.30936.13253.sendpatchset@thinktank.campus.ltu.se> <20071030145155.GL32359@parisc-linux.org> <47274781.3030606@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47274781.3030606@student.ltu.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 04:02:25PM +0100, Richard Knutsson wrote:
> Matthew Wilcox wrote:
> >On Tue, Oct 30, 2007 at 11:54:22AM +0100, Richard Knutsson wrote:
> >  
> >>Convert to use the generic boolean.
> >>-	u8 initialized;
> >>-	u8 in_use;		/* is the management node open*/
> >>+	bool initialized:8;
> >>+	bool in_use:8;		/* is the management node open*/
> >>    
> >
> >Are you serious?
> >  
> Well, yes. It is since it was defined to really be 8 bits before, and 
> there is no reason why a boolean would be 8 bits and not 1 or 16.
> If it is overly cautious/not needed, then I don't mind removing the ':8'...

What's wrong with leaving it as 'u8'?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
