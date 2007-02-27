Return-Path: <linux-kernel-owner+w=401wt.eu-S1750767AbXB0L1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750767AbXB0L1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXB0L1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:27:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:33708 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXB0L1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:27:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BXOcOker2o4ddWMCKTAKP/Zteef4VaJUKXWDT2m4T8Gq3BEUINL42UL5cUnb/+IbNTa0gfHDc6jGL/P/xa2UdUK8as4hWG7JUL26SVUcXA4hEH7amiPccR9Jrzgqn4G8cE0zfmPn74tvbvyJuXhCDZKBUBFdyGUqrhogDYJtbWU=
Message-ID: <9a8748490702270327y513bc4e8ua4c7494d0beacfc4@mail.gmail.com>
Date: Tue, 27 Feb 2007 12:27:42 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Hang when shutting down - seems umount and NFS related - kernel version 2.6.18.1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net
In-Reply-To: <45E36AEB.7030800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490702261504n147aa444y779153c03a2d44a2@mail.gmail.com>
	 <45E36AEB.7030800@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> Jesper Juhl wrote:
> > I have a server that has the sole job of serving up a bunch of NFS
> > filesystems to webservers. The server is running kernel 2.6.18.1
> >
> > A few days ago when attempting to reboot the server, the shutdown
> > process hung with a backtrace on the console. A photo was taken and is
> > available here:
> >  http://www.kernel.org/pub/linux/kernel/people/juhl/images/DSC00504.jpg
> >
> > A quick (incomplete) text transcript of the photo is here:
> >
> > EIP: [<c01a51a0>] nfs_clear_inode+0x61/0x6b SS:ESP 0068:eb476ee4
> > BUG: warning at kernel/exit.c:855/do_exit()
>
> The real oops has scrolled off the screen.
>
I feared that might be the case, but still wanted to report the data I
had just in case something useful could be gleaned from it.
Ohh well, can't win 'em all...  Thanks for replying.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
