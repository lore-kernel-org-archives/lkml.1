Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYLJW5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYLJW5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYLJW5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:57:08 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:36555 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYLJW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:57:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Np81IB6iQlNBiHR0SzrcfoCJSgvFCjRRKFc40ejDNtPL2lK0QR+t/iM2W/ECoPywpu
         6XSkG+mnNZFbWX+QEgQ8jP8iS4Qqyr3so++0c1KQwUSj4/Hf/tcjYOsFsj0kKXrWmNQk
         bISRqrS4riw3KanvYMU/rbD8C96Ms/rwjR++A=
Date: Thu, 11 Dec 2008 01:48:54 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Julia Lawall <julia@diku.dk>,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/28] drivers/base/platform.c: Drop return value from
	platform_driver remove functions
Message-ID: <20081210224854.GA5167@zarina>
Reply-To: cbouatmailru@gmail.com
References: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk> <20081210163819.17cf4628@lxorguk.ukuu.org.uk> <45755.88.114.236.15.1228932236.squirrel@webmail.movial.fi> <20081210212659.GA6132@zarina> <42393.88.114.236.15.1228946794.squirrel@webmail.movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <42393.88.114.236.15.1228946794.squirrel@webmail.movial.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 12:06:34AM +0200, Vorobiev Dmitri wrote:
> > On Wed, Dec 10, 2008 at 08:03:56PM +0200, Vorobiev Dmitri wrote:
> >> > On Wed, 10 Dec 2008 17:26:26 +0100 (CET)
> >> > Julia Lawall <julia@diku.dk> wrote:
> >> >
> >> >> From: Julia Lawall <julia@diku.dk>
> >> >>
> >> >> The return value of the remove function of a driver structure, and
> >> thus
> >> >> of
> >> >> a platform_driver structure, is ultimately ignored
> >> >
> >> > Currently
> >>
> >> Are there really any plans about actually using the return value?
> >
> > It's often used by the drivers, but currently not handled by
> > the subsystem. For example, _remove() callback might return -EBUSY
> > or -EAGAIN, which means that whoever called the _remove() should
> > try later.
> 
> Sure, it's easy to find drivers, which that return a non-dummy value from
> the remove() callback thinking that someone up there will take care of the
> error.
> 
> The point is, however, that
[...]
> SCSI maintainers do not apply the patch

This sometimes happens. You can try to repost your original patch, and
in the commit message briefly describe that return type is unlikely to
change, and give a pointer to this discussion.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
