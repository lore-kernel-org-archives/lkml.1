Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZG0Myj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZG0Myj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZG0Myi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:54:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbZG0Myi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:54:38 -0400
Subject: Re: [PATCH] Allow userspace block device implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Zachary Amsden <zamsden@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, Tejun Heo <tj@kernel.org>,
       miklos <miklos@szeredi.hu>
In-Reply-To: <4A6D79F6.3050509@redhat.com>
References: <4A6D79F6.3050509@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 14:56:05 +0200
Message-Id: <1248699365.6987.1628.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-26 at 23:57 -1000, Zachary Amsden wrote:
> Well, it may be a good, bad, idiotic or brilliant idea depending on your
> personal philosophy.  I went down this route out of pragmatism.
> Hopefully I have not fully re-invented the wheel.
> 
> The patch included allows one to implement a kernel level block device
> in userspace, using an ioctl() based interface to create a sized device
> with given properties, and then receive and respond to bio requests
> issued to the device.  One can poll on the associated control socket to
> allow efficient servicing of device requests.  So far only strict copy
> to/from user memory is supported, there is no fancy page flipping or
> mapping operations.

Somehow this made me think of FUSE/CUSE... should this be named aBUSE?
Oh wait it is :-), what I'm after is I guess is, can we share some of
the FUSE/CUSE code?

I can only imagine the fun we'll end up with when someone tries swapon
on a user-space block device.. aptly named.

