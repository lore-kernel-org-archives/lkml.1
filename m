Return-Path: <linux-kernel-owner+w=401wt.eu-S1763529AbXJZUa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763529AbXJZUa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbXJZUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:30:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:58637 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbXJZUaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=n6T2cjOKgRbutVrLYh4iu9pGI6lylTeijosQugEtPoKvejN3pCFFkHGQdHWQpQiUcLWl3S5QMRX6CFgwcsRz8T6SccZNiKkN+VkarKWEp4Ha2+6nnQkRaYj6Tfvq6S/gifFjISbdVAtjWB9J4PITle3EOJ0MNe8yG9d5ur6t0Ck=
Message-ID: <3ae72650710261330p6d3af8eqe5dd5977bb58a157@mail.gmail.com>
Date: Fri, 26 Oct 2007 22:30:18 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Amit Shah" <amitshah@gmx.net>
Subject: Re: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <877aabc40710261325p4d59ca4dwa00a559f84608f27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
	 <20071026155058.GC23016@kroah.com>
	 <877aabc40710261025v2f53423el6bb63fc2024a0ffd@mail.gmail.com>
	 <20071026191534.GA24596@kroah.com>
	 <877aabc40710261325p4d59ca4dwa00a559f84608f27@mail.gmail.com>
X-Google-Sender-Auth: 4a492d5a022bab0f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Amit Shah <amitshah@gmx.net> wrote:
> On 27/10/2007, Greg KH <greg@kroah.com> wrote:
> > On Fri, Oct 26, 2007 at 10:55:15PM +0530, Amit Shah wrote:
> > > On 26/10/2007, Greg KH <greg@kroah.com> wrote:
> > > > On Fri, Oct 26, 2007 at 12:44:38PM +0530, Amit Shah wrote:
> > > > > On 2.6.24-rc1, I get this for all my eth interfaces:
> > > > >
> > > > > [  150.389821] sysfs: duplicate filename 'eth1_rename' can not be created
> > > > > [  150.389824] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > >
> > > > I sent out the patch below for comments, yet no one did :(
> > > >
> > > > Can you try it out and let me know if it works for you or not?
> > >
> > > No, doesn't help.
> >
> > Ugh, thanks.  There's got to be something else going on in the network
> > layer with this.
> >
> > I'll try to reproduce it on a different distro on a different box later
> > this afternoon...
>
> I'm using kubuntu 7.04 (feisty), if it helps.

This is expected to fix the issue:
  http://lkml.org/lkml/2007/10/26/359

Kay
