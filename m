Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZCYXqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZCYXqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZCYXqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:46:14 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54478 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbZCYXqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:46:13 -0400
Date: Thu, 26 Mar 2009 10:46:04 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325234604.GA14828@brong.net>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 04:23:08PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 25 Mar 2009, Theodore Tso wrote:
> > > 
> > > The problem being that unlike the ratio, there's no sane default value 
> > > that you can at least argue is not _entirely_ pointless.
> > 
> > Well, if the maximum time that someone wants to wait for an fsync() to
> > return is one second, and the RAID array can write 100MB/sec
> 
> How are you going to tell the kernel that the RAID array can write 
> 100MB/s?
> 
> The kernel has no idea.

Not at boot up, but after it's been using the RAID array for a little
while it could...

Bron (... imagining a tunable "max_fsync_wait_target_centisecs = 100" 
      which caused the kernel to notice how long flushes were taking
      and tune its buffer sizes to be approximately right over time )
