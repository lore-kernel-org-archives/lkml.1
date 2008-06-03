Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYFCRws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYFCRws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYFCRwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:52:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60289 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYFCRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:52:38 -0400
X-Sasl-enc: t7NfZ3ZFy5l9XAybMKJsJTiOUF4RBYqyRqfGvGIfheUK 1212515557
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603175053.GF28946@ZenIV.linux.org.uk>
References: <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <20080603164102.GB28946@ZenIV.linux.org.uk>
	 <20080603165042.GC28946@ZenIV.linux.org.uk>
	 <1212514104.3025.110.camel@raven.themaw.net>
	 <20080603174125.GE28946@ZenIV.linux.org.uk>
	 <1212514893.3025.123.camel@raven.themaw.net>
	 <20080603175053.GF28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 01:49:22 +0800
Message-Id: <1212515363.3025.125.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 18:50 +0100, Al Viro wrote:
> On Wed, Jun 04, 2008 at 01:41:32AM +0800, Ian Kent wrote:
> 
> > OK, I'll need to look at vfs_readdir().
> > I thought vfs_readdir() would take the containing directory mutex as
> > does ->lookup().
> 
> vfs_readdir() takes i_mutex on directory it reads.  I.e. on the victim
> in this case.  lookup has i_mutex on directory it does lookup in, i.e.
> root in this case...

Hahaha, yes, I'll need to go back and re-read that bit of code, sorry.

