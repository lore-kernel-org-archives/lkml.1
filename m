Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbXCEMjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbXCEMjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXCEMjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:39:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55302 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbXCEMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:39:46 -0500
Date: Mon, 5 Mar 2007 13:39:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Andreas Krebbel <krebbel1@de.ibm.com>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Message-ID: <20070305123940.GA13850@one.firstfloor.org>
References: <45E5913D.3080505@redhat.com> <200703050218.25028.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703050218.25028.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 02:18:24AM +0100, Arnd Bergmann wrote:
> On Wednesday 28 February 2007, Chuck Ebbert wrote:
> > Can we just put a canary in the threadinfo and check it on every
> > task switch? What are the drawbacks?
> 
> It's not completely reliable, in case of functions that allocate
> far too much stack space. You might want to take a look at the
> gcc support that Andreas Krebbel implemented for s390 to check
> for stack overflows:

I hacked this up for x86-64 too at some point (using 
the gprof support). However it's quite slow.

Here's the old 2.4 patch:

ftp://ftp.x86-64.org/pub/linux/debug/stackcheck-1

-Andi
