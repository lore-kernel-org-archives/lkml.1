Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZLMTUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZLMTUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZLMTUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:20:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54417 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753985AbZLMTUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:20:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kb5rK28DpKc+J3v9YFvm9wwvP1EvQcnCrON5cxz70o/TJ1cbUMA+HzYneaCs3RRCIW
         MkwYqi2NmfrW8ssYzLB73VF4ru/A3qy/ACK+CK3e1eBpiwWwkcyhHSlTMqVKhF7ucbuR
         xzyTPSb6p4yaO0EmPH1ZpTDWeWPxvXQvAOEq0=
Date: Sun, 13 Dec 2009 20:20:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091213192003.GC7297@nowhere>
References: <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain> <20091212214235.31429790@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain> <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain> <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain> <20091213065844.GA20244@elte.hu> <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain> <20091213181726.GA14558@elte.hu> <20091213190410.GA7297@nowhere> <1260731354.2612.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260731354.2612.14.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 02:09:14PM -0500, Trond Myklebust wrote:
> On Sun, 2009-12-13 at 20:04 +0100, Frederic Weisbecker wrote: 
> > In the above cases we have the following comment:
> > 
> > /* Protect inode->i_flock using the BKL */
> > 
> > And really it doesn't seem to protect anything else,
> > fortunately it is acquired in a short path.
> 
> As I said in my reply, this is the tough one, because the BKL protection
> is imposed by the VFS locking scheme used in fs/locks.c.
> 
> There is a similar dependency imposed upon fs/lockd/



Ok.


> > fs/nfs/super.c: unlock_kernel();
> > fs/nfs/super.c: unlock_kernel();
> > 
> > Protect the mount/unmount path, a bit trickier there.
> > 
> > But really that looks way much easier to fix than it was
> > with reiserfs.
> 
> All the other cases you list should be fixed in the GIT PULL request
> that I just put out.
> 


Cool, thanks a lot!

