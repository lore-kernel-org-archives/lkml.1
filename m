Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbZJaD7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbZJaD7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 23:59:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932849AbZJaD67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 23:58:59 -0400
Received: from mailout-apollo.uni-duesseldorf.de ([134.99.128.36]:46691 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757640AbZJaD67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 23:58:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 31 Oct 2009 04:58:55 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: Fwd: [PATCH] [RFC] ataflop: remove buggy IRQ disable from
 do_fd_request()
In-reply-to: <m3k4yqfmeb.fsf@hase.home>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k <linux-m68k@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Message-id: <alpine.DEB.2.00.0910310455190.17692@zirkon.biophys.uni-duesseldorf.de>
References: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de>
 <10f740e80910100201n30367714uc57ec3c9c39b92af@mail.gmail.com>
 <alpine.DEB.2.00.0910110846420.20140@zirkon.biophys.uni-duesseldorf.de>
 <alpine.LSU.2.00.0910121106330.19284@wotan.suse.de>
 <alpine.DEB.2.00.0910182126120.6395@zirkon.biophys.uni-duesseldorf.de>
 <alpine.LSU.2.00.0910190932030.8582@wotan.suse.de>
 <alpine.DEB.2.00.0910200847320.8658@zirkon.biophys.uni-duesseldorf.de>
 <m3k4yqfmeb.fsf@hase.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

> > That. too :-) What I meant to say - the reason why someone chose to comment out 
> > the original sti() wasn't really clear. I guess the reason for that particular 
> > change has been lost in the pre-git or bk era.
> 
> FWIW, this can be traced back to as much as the 2.0 era (1996).  Going

Thanks, that definitely settles it. Around that time was my only exposure to the 
floppy code (making mtools work). Brings back some memories ...

> back further is difficult because a lot of files on ftp.uni-erlangen.de
> are corrupt.

You haven't really dug around on the old FTP site just for this? 

Cheers,

	Michael

