Return-Path: <linux-kernel-owner+w=401wt.eu-S1030505AbXCSS23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030505AbXCSS23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030503AbXCSS22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:28:28 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47585 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030495AbXCSS21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:28:27 -0400
X-Greylist: delayed 2276 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 14:28:27 EDT
Message-ID: <45FECD45.20705@cs.wisc.edu>
Date: Mon, 19 Mar 2007 12:49:57 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 1.5 (X11/20060313)
MIME-Version: 1.0
To: Andreas Steinmetz <ast@domdv.de>
CC: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
References: <45FDDA8E.8030100@domdv.de>
In-Reply-To: <45FDDA8E.8030100@domdv.de>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Steinmetz wrote:
> As posted to lkml and linux-scsi on 2007-03-15 without reply, see
> http://marc.info/?l=linux-kernel&m=117395128412313&w=2 for original post:
> 
> It is not so nice when one can write backup tapes but the tapes cannot
> be read. I don't know if memory management or the st driver is the
> culprit, but this is a not so nice situation.
> 
> I can't even say if the tapes are written correctly as I can't read them
> (one does not reboot production machines back to 2.4.x just to try to
> read a backup tape - I don't have 2.6.x older than 2.6.20 on these
> machines).

Could you try this patch
http://marc.info/?l=linux-scsi&m=116464965414878&w=2
I thought st was modified to not send offsets in the last elements but
it looks like it wasn't.
