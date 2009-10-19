Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZJSTsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZJSTsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbZJSTsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:48:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:20877 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZJSTsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:48:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N+S5vn2dRCnmhWx4+80rUkxtvdIy4i0ymgRK7ft6dS9riRfGDsP2nTFOaSWiJlugam
         cc6EL2Y9Ev2a9OtUtFYQnc6Eh/A/b9DzGQp5xrLbcmV0Ki21fYP+IRxtM9c2c4tiyNvj
         GpCONbQtaNZRLKneRbMdnCzrqKxmkTs+428Nc=
Date: Mon, 19 Oct 2009 21:48:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: hw-breakpoints: Actually flush thread
	breakpoints in flush_thread().
Message-ID: <20091019194842.GD4880@nowhere>
References: <20091005102306.GA7889@linux-sh.org> <20091005104955.GA14852@in.ibm.com> <20091009034003.GA7747@linux-sh.org> <20091017234250.GC10344@nowhere> <20091018062558.GA20535@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018062558.GA20535@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 03:25:58PM +0900, Paul Mundt wrote:
> Thanks. If you're setting up a tree somewhere can you let me know where
> it will be hosted? I'm pretty much done with the SH support for the
> existing topic branch in -tip, but if it's being reworked, then I'd like
> to get my changes reworked and integrated as soon as possible.


Oh you have based SH breakpoint support on top of the current breakpoint
API in -tip?

Hm, you should have talked to us about that since it's being reworked.

I'll probably post soon the rebase on top of perf events. And even if
it gets merged in -tip, it should still be considered as very unstable.

May be should you better wait for it to get upstream?


