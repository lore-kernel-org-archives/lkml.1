Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbXJ1HRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbXJ1HRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 03:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbXJ1HRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 03:17:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:37887 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXJ1HRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 03:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FWTnIEeVLV31u1t57kcqK4rvGdYjmUDLicD4sChTawz//1XOmBeGzNobX2KKQtjE1iVWP7XzI3liN2moe9pkAxX2WYE9BIAYSK/hy0C19visOANu+bYE20oNd75l2Ml3NuYHXlsuwvxxgzOVC91jR0qRogiilZy+n42uMsGjvrM=
Message-ID: <877aabc40710280017i5bc90656p5b1a31d81af7ffe@mail.gmail.com>
Date: Sun, 28 Oct 2007 12:47:00 +0530
From: "Amit Shah" <amitshah@gmx.net>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <3ae72650710261330p6d3af8eqe5dd5977bb58a157@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com>
	 <20071026155058.GC23016@kroah.com>
	 <877aabc40710261025v2f53423el6bb63fc2024a0ffd@mail.gmail.com>
	 <20071026191534.GA24596@kroah.com>
	 <877aabc40710261325p4d59ca4dwa00a559f84608f27@mail.gmail.com>
	 <3ae72650710261330p6d3af8eqe5dd5977bb58a157@mail.gmail.com>
X-Google-Sender-Auth: 527b0d3f412a4d08
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/10/2007, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On 10/26/07, Amit Shah <amitshah@gmx.net> wrote:
> > On 27/10/2007, Greg KH <greg@kroah.com> wrote:
> > > On Fri, Oct 26, 2007 at 10:55:15PM +0530, Amit Shah wrote:
> > > > On 26/10/2007, Greg KH <greg@kroah.com> wrote:
> > > > > On Fri, Oct 26, 2007 at 12:44:38PM +0530, Amit Shah wrote:
> > > > > > On 2.6.24-rc1, I get this for all my eth interfaces:
> > > > > >
> > > > > > [  150.389821] sysfs: duplicate filename 'eth1_rename' can not be created
> > > > > > [  150.389824] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > > >
> > > > > I sent out the patch below for comments, yet no one did :(
> > > > >
> > > > > Can you try it out and let me know if it works for you or not?
> > > >
> > > > No, doesn't help.
> > >
> > > Ugh, thanks.  There's got to be something else going on in the network
> > > layer with this.
> > >
> > > I'll try to reproduce it on a different distro on a different box later
> > > this afternoon...
> >
> > I'm using kubuntu 7.04 (feisty), if it helps.
>
> This is expected to fix the issue:
>   http://lkml.org/lkml/2007/10/26/359

Thanks, this patch fixed it.

-- 
Amit Shah
http://www.amitshah.net/
