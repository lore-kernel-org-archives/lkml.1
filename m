Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbXF0Jzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbXF0Jzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 05:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXF0Jz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 05:55:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34767 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXF0Jz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 05:55:28 -0400
Date: Wed, 27 Jun 2007 10:55:27 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Zolt?n HUBERT <zoltan.hubert@zzaero.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
Message-ID: <20070627095526.GM21478@ftp.linux.org.uk>
References: <200706212349.54983.zoltan.hubert@zzaero.com> <200706261637.22820.zoltan.hubert@zzaero.com> <6FD45914-1793-45D5-B0A1-F5D32ED38017@e18.physik.tu-muenchen.de> <200706271118.36985.zoltan.hubert@zzaero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706271118.36985.zoltan.hubert@zzaero.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 11:18:36AM +0200, Zolt?n HUBERT wrote:
> I'm a system engineer, and a "stable" system is one where 
> the interfaces are stable. Individual components can 
> change, and do change, but if you change fundamental 
> interfaces it is not the same system. Of course I 
> understand that "sometimes" fundamental things have to 
> change, but here "sometimes" is the keyword. If its 
> "anytime" it simply is no stable system. And yes, designing 
> and maintaining interfaces is a very difficult job.

What makes you think that module interfaces _exist_?  Over the years
we'd got a pile of exports.  Maybe 5-10% of it could form several
more or less sane interfaces.  And that's being very optimistic.
But try to get those interfaces and guess who'll scream bloody
murder?  That's right, the 3rd-party module developers.  The same
people who presumably want stability.  Because all that dreck had
been exported on someone's requests.
 
> I don't remember how it was during 2.4 and before, but I 
> find it very suspicious that SuSE and RedHat only provide 
> 2.6.10 and 2.6.9 for their OS. It looks as if THEY didn't 
> trust 2.6.x to be a replacement to 2.6.y

Eh?  Funny, but in the next xterm I've got an ssh session to RHEL-5
box.  2.6.18+many backported patches...  FC is simply following
mainline, but that's a separate story...

> And as I understand it, this is (was ?) the whole point of 
> stable/development kernels. "We" can trust a newer stable 
> kernel to be a drop-in replacement for an older stable 
> kernel (from the same series), while development kernels 
> need time to stabilise with the new whizz-bang-pfouit stuff 
> that you all so nicely add. 

"Drop-in" in which sense?  That out-of-tree modules keep working?
Not really...
