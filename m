Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbXD0U4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbXD0U4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbXD0U4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:56:40 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:26658 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbXD0U4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:56:37 -0400
Subject: Re: [patch 18/38] Improved oops output.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <p733b2l3ct2.fsf@bingen.suse.de>
References: <20070427140503.087958775@de.ibm.com>
	 <20070427140516.013904506@de.ibm.com>  <p733b2l3ct2.fsf@bingen.suse.de>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 27 Apr 2007 22:56:49 +0200
Message-Id: <1177707409.7451.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 20:14 +0200, Andi Kleen wrote:
> Martin Schwidefsky <schwidefsky@de.ibm.com> writes:
> 
> > Second a disassembler is added that decodes the instructions surrounding
> > the faulting PSW. 
> 
> Is that really needed? I use a simple wrapper around as/objdump for this
> and it works great.
> 
> (ftp://ftp.firstfloor.org/pub/ak/shell/decodecode) 

It is not absolutly needed but it is damn convenient. Usually I can
immediatly see the reason for the oops. And the size is only 8KB which
is next to nothing.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


