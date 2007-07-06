Return-Path: <linux-kernel-owner+w=401wt.eu-S1763774AbXGFTFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763774AbXGFTFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763377AbXGFTFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:05:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41997 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763231AbXGFTE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:04:59 -0400
Date: Fri, 6 Jul 2007 21:04:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Hiroaki Fuse <Hiroaki_Fuse@hq.scei.sony.co.jp>
Subject: Re: Too verbose compat_ioctl messages?
Message-ID: <20070706190456.GC8174@one.firstfloor.org>
References: <Pine.LNX.4.62.0707061431360.1203@pademelon.sonytel.be> <468E6E33.3040000@zytor.com> <p737ipd1jsg.fsf@bingen.suse.de> <468E8B07.2030404@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468E8B07.2030404@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 11:33:43AM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >"H. Peter Anvin" <hpa@zytor.com> writes:
> >  
> >>For one thing, it looks like we're returning the wrong thing (EINVAL
> >>rather than ENOTTY) across the board.  This was unfortunately a common
> >>misunderstanding with non-tty-related ioctls in the early days of Linux.
> >>    
> >
> >ENOTTY is so excessively misnamed that it is actually surprising
> >anybody ever got that "right" (for very small values of right i guess)
> >  
> 
> But it *isn't* a typewriter. 

Most ioctls are not related to ttys in any way.

-Andi
