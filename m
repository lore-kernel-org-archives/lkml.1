Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbXFSJTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbXFSJTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXFSJTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:19:03 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:52415 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXFSJTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:19:01 -0400
Date: Tue, 19 Jun 2007 18:17:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 5/6] Move psw_set_key.
Message-ID: <20070619091727.GB23697@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20070619084516.457715754@de.ibm.com> <20070619084643.095486838@de.ibm.com> <20070619084516.457715754@de.ibm.com> <20070619084642.673859525@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619084643.095486838@de.ibm.com> <20070619084642.673859525@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 10:45:21AM +0200, Martin Schwidefsky wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Move psw_set_key() from ptrace.h to processor.h which is a more
> suitable place for it. In addition the moves makes the function
> invisible to user space.
> 
>  arch/s390/kernel/traps.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

On Tue, Jun 19, 2007 at 10:45:22AM +0200, Martin Schwidefsky wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> This is mainly to switch off all potentially debugging stuff that
> won't report anything useful after an oops happened.
> Besided that setting pause_on_oops will work too, but doesn't make
> too much sense on s390.
> 
>  include/asm-s390/processor.h |    5 +++++
>  include/asm-s390/ptrace.h    |    9 +--------
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
These changelog does not match the patch, they're reversed.. :-)
