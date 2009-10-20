Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbZJTJ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbZJTJ1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 05:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZJTJ1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 05:27:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbZJTJ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 05:27:53 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k <linux-m68k@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] [RFC] ataflop: remove buggy IRQ disable from do_fd_request()
References: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de>
	<10f740e80910100201n30367714uc57ec3c9c39b92af@mail.gmail.com>
	<alpine.DEB.2.00.0910110846420.20140@zirkon.biophys.uni-duesseldorf.de>
	<alpine.LSU.2.00.0910121106330.19284@wotan.suse.de>
	<alpine.DEB.2.00.0910182126120.6395@zirkon.biophys.uni-duesseldorf.de>
	<alpine.LSU.2.00.0910190932030.8582@wotan.suse.de>
	<alpine.DEB.2.00.0910200847320.8658@zirkon.biophys.uni-duesseldorf.de>
X-Yow: It's strange, but I'm only TRULY ALIVE when I'm covered in POLKA DOTS
 and TACO SAUCE...
Date: Tue, 20 Oct 2009 11:24:44 +0200
In-Reply-To: <alpine.DEB.2.00.0910200847320.8658@zirkon.biophys.uni-duesseldorf.de>
	(Michael Schmitz's message of "Tue, 20 Oct 2009 08:51:08 +0200
	(CEST)")
Message-ID: <m3k4yqfmeb.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Schmitz <schmitz@biophys.uni-duesseldorf.de> writes:

> That. too :-) What I meant to say - the reason why someone chose to comment out 
> the original sti() wasn't really clear. I guess the reason for that particular 
> change has been lost in the pre-git or bk era.

FWIW, this can be traced back to as much as the 2.0 era (1996).  Going
back further is difficult because a lot of files on ftp.uni-erlangen.de
are corrupt.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
