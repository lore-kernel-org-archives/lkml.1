Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbXLUDus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbXLUDus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbXLUDui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:50:38 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:60718 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbXLUDui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:50:38 -0500
Date: Thu, 20 Dec 2007 22:50:36 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Junio C Hamano <gitster@pobox.com>, Git Mailing List <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc6
Message-ID: <20071221035036.GE8535@fattire.cabal.ca>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org> <20071221024805.GB8535@fattire.cabal.ca> <20071221030152.GC8535@fattire.cabal.ca> <alpine.LFD.0.9999.0712201937470.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712201937470.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 07:49:05PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 20 Dec 2007, Kyle McMartin wrote:
> > 
> > I think I see the problem, it's lack of context in the diff,
> 
> No, the problem is that "git diff" is apparently broken by a recent 
> optimization. The diff is simply broken.
> 
> The tar-ball and the git archive itself is fine, but yes, the diff from 
> 2.6.23 to 2.6.24-rc6 is bad. It's the "trim_common_tail()" optimization 
> that has caused way too much pain.
> 
> Sorry about that, I'll fix it up asap.
> 

no biggie, thanks!

cheers, Kyle
