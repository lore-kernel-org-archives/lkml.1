Return-Path: <linux-kernel-owner+w=401wt.eu-S1763201AbXJZUZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763201AbXJZUZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJZUZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:25:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:13916 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbXJZUZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:25:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aggK3pUOevpXq5MsNZAIVxlTlQ9482IZbv48WQhdHTdvszetH8DtqdR6g11Takj4wGnjygdIrw4qFF9sd6iIZMFdc1XR9uy8YNiXHQH8MMNcd/8reJZ6swN9JKzsS3N3hJLcFOjmGnreAkDmJwGGwhCLYLBBPHIPywyvvvoe8CU=
Message-ID: <877aabc40710261325p4d59ca4dwa00a559f84608f27@mail.gmail.com>
Date: Sat, 27 Oct 2007 01:55:03 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Greg KH" <greg@kroah.com>
Subject: Re: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071026191534.GA24596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
	 <20071026155058.GC23016@kroah.com>
	 <877aabc40710261025v2f53423el6bb63fc2024a0ffd@mail.gmail.com>
	 <20071026191534.GA24596@kroah.com>
X-Google-Sender-Auth: ef09982bfd124819
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/2007, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 26, 2007 at 10:55:15PM +0530, Amit Shah wrote:
> > On 26/10/2007, Greg KH <greg@kroah.com> wrote:
> > > On Fri, Oct 26, 2007 at 12:44:38PM +0530, Amit Shah wrote:
> > > > On 2.6.24-rc1, I get this for all my eth interfaces:
> > > >
> > > > [  150.389821] sysfs: duplicate filename 'eth1_rename' can not be created
> > > > [  150.389824] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > >
> > > I sent out the patch below for comments, yet no one did :(
> > >
> > > Can you try it out and let me know if it works for you or not?
> >
> > No, doesn't help.
>
> Ugh, thanks.  There's got to be something else going on in the network
> layer with this.
>
> I'll try to reproduce it on a different distro on a different box later
> this afternoon...

I'm using kubuntu 7.04 (feisty), if it helps.

Amit.

-- 
Amit Shah
http://www.amitshah.net/
