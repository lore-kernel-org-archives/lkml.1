Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZF2XyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZF2XyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZF2XyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:54:11 -0400
Received: from kroah.org ([198.145.64.141]:41858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZF2XyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:54:11 -0400
Date: Mon, 29 Jun 2009 16:44:36 -0700
From: Greg KH <greg@kroah.com>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] [PATCH] FLAT: fix uninitialized ptr with shared libs
Message-ID: <20090629234436.GA28649@kroah.com>
References: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain> <1245699332-1872-1-git-send-email-vapier@gentoo.org> <alpine.LFD.2.01.0906221338360.3240@localhost.localdomain> <4A40AAEA.4040100@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40AAEA.4040100@t-online.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 11:14:02AM +0100, Bernd Schmidt wrote:
> Linus Torvalds wrote:
> > IOW, the whole patch really seems to be total and utter crap. Why didn't 
> > people spend a bit more effort lookin at it?
> 
> Just sloppiness, I'm afraid.
> 
> > IOW, shouldn't the patch be something like the appended?
> > 
> > UNTESTED. I did not compile this, or the previous patch. I have not tried 
> > it. I'm not going to commit it. I'm hoping to get a patch back that is 
> > tested and/or explains my concerns with the previous one..
> 
> Your version seems to work fine.  Please apply it.

Linus, this doesn't seem to be in your tree yet.  Did it get lost in the
noise?

thanks,

greg k-h
