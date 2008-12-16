Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYLPTIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYLPTIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYLPTIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:08:39 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:56226 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYLPTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:08:38 -0500
Date: Tue, 16 Dec 2008 20:10:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: GIT head doesn't seem to want to build on 32bit..
Message-ID: <20081216191008.GB25108@uranus.ravnborg.org>
References: <20081216172859.5bc030b6@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0812160946410.14014@localhost.localdomain> <20081216181133.2342b49e@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0812161043240.14014@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812161043240.14014@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 10:48:42AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 16 Dec 2008, Alan Cox wrote:
> > 
> > I built a 64bit kernel from the same source tree first, then did make
> > mrproper, then it broke. I'll investigate further.
> 
> Maybe you did just "make clean"? That leaves at least the "include/asm" 
> symlink around. 
For x86 (32 and 64 bit) the symlink is the same these days.
If it was wrong then kbuild would complain.

	Sam
