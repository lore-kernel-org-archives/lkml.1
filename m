Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbXBULoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbXBULoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXBULoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:44:12 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:60793 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435AbXBULoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:44:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gOKhjinGLmp/b5AOh6BKrVWrg49ye3vfkkUh/e15UInVpekWKsjNB/uj1xe6aHWz+V3W/I3Q5+H/2Sr8thFkQGXK3IeHagnTu8XbmNikIhKtcgn+IEpLqajkZrnIQfeLxpUOFtkdNJqbra2QbS6QuxPZCU+b0oAfh8Lu9BYvyCI=
Message-ID: <9a8748490702210344r2f9ed9cbs892e2e5f2570d546@mail.gmail.com>
Date: Wed, 21 Feb 2007 12:44:10 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: 2.6.13.4 - "lockd: weird return 1 for CANCEL call"
Cc: nfs@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <17884.11265.145106.290158@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490702210246j38a1ca4bi8de371ba6829ada9@mail.gmail.com>
	 <17884.11265.145106.290158@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/07, Neil Brown <neilb@suse.de> wrote:
> On Wednesday February 21, jesper.juhl@gmail.com wrote:
> > Greetings,
> >
> > I just got a unusual message from lockd on a webserver running a
> > custom compiled 2.6.13.4 (yes it is ancient, I know).
> >
> > # uname -a
> > Linux webserv.somedomain.example 2.6.13.4 #1 SMP Wed Nov 16 10:03:05
> > CET 2005 i686 unknown
> >
> > # dmesg | tail -n 3
> > do_vfs_lock: VFS is out of sync with lock manager!
> > lockd: weird return 1 for CANCEL call
> > lockd: weird return 1 for CANCEL call
> >
> > The server seems to be running fine, so I'm not really worried, but I
> > thought maybe someone would like to know. :-)
>
> Thanks.
> Don't be worried.  They are both warning about perfectly acceptable
> (though uncommon) behaviour.  These warnings have since been removed.
>
I know the "VFS is out of sync with lock manager" warning has been
removed (I pushed quite a bit to get that done myself ;) I was just
providing context.  The one I had not seen before was the "weird
return ..." one.

> A process was interrupted while trying to get a lock, so the NFS
> client didn't know if it actually had the lock or not.
> When the process exited, the tried to cancel the lock just to be on
> the safe side and was told that it didn't own any such lock.
>
Thanks a lot for that very nice explanation.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
