Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbYLMQof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbYLMQof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYLMQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:44:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49060 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYLMQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:44:27 -0500
Subject: Re: [RFC PATCH -v4 13/14] inotify: reimplement inotify using
 fsnotify
From: Eric Paris <eparis@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20081213032255.GH807@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215222.27112.33426.stgit@paris.rdu.redhat.com>
	 <20081213032255.GH807@ioremap.net>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 11:44:01 -0500
Message-Id: <1229186641.29167.110.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 06:22 +0300, Evgeniy Polyakov wrote:
> On Fri, Dec 12, 2008 at 04:52:23PM -0500, Eric Paris (eparis@redhat.com) wrote:
> > Yes, holy shit, I'm trying to reimplement inotify as fsnotify...
> 
> While you are at it, please update inode_setattr() so that it dropped
> inotify watches if new permissions do not allow to read data.

Now this isn't so easy....   Do you have suggestions how to do this with
inotify as it stands today?  the vfs needs to know what's hanging on the
open fd in userspace...    Not a bad idea.  I'll look, but clearly not a
core patch....

-Eric

