Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZI2Wlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZI2Wlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 18:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZI2Wla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 18:41:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37911 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750873AbZI2Wla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 18:41:30 -0400
Date: Tue, 29 Sep 2009 23:39:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dhowells@redhat.com,
       akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not
 used
Message-ID: <20090929233952.2c224303@lxorguk.ukuu.org.uk>
In-Reply-To: <4079.1254249610@redhat.com>
References: <alpine.LFD.2.01.0909290936430.6996@localhost.localdomain>
	<alpine.LFD.2.01.0909280743310.3349@localhost.localdomain>
	<20090928135332.4300.56046.stgit@warthog.procyon.org.uk>
	<20090928151628.62955233@lxorguk.ukuu.org.uk>
	<395.1254239745@redhat.com>
	<alpine.LFD.2.01.0909290909280.6996@localhost.localdomain>
	<4079.1254249610@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 19:40:10 +0100
David Howells <dhowells@redhat.com> wrote:

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Comments?
> 
> Perhaps add legacy pty support to the list of features to be removed and see
> who howls.

You do break stuff still and they are part of the API, ABI and namespace
so you break compatibility.

> >  static struct tty_driver *pty_driver, *pty_slave_driver;
> 
> These shouldn't be global variables.  They're only used within
> legacy_pty_init().  That's a side issue, however.

Agreed
