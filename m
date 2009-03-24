Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZCXWUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZCXWUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZCXWTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:19:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38539 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753768AbZCXWTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:19:32 -0400
Date: Tue, 24 Mar 2009 22:20:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: stoyboyker@gmail.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 07/13] [usb] changed ioctls to unlocked
Message-ID: <20090324222015.601fc205@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324220953.GA5835@kroah.com>
References: <1237929168-15341-8-git-send-email-stoyboyker@gmail.com>
	<20090324220953.GA5835@kroah.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 15:09:53 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Mar 24, 2009 at 04:12:42PM -0500, stoyboyker@gmail.com wrote:
> > From: Stoyan Gaydarov <stoyboyker@gmail.com>
> > 
> > Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> > ---
> >  drivers/usb/mon/mon_bin.c |   53 ++++++++++++++++++++++++++++++++------------
> >  1 files changed, 38 insertions(+), 15 deletions(-)
> 
> NAK, you're just pushing lock_kernel() down for no good reason.

Actually the underlying reason is to get rid of the old ->ioctl hook
entirely so it makes sense to do this but yes for simple drivers they
just want fixing.
