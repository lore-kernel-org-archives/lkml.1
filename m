Return-Path: <linux-kernel-owner+w=401wt.eu-S936232AbXFFWFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232AbXFFWFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935961AbXFFWFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:05:37 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58864 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935860AbXFFWFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:05:36 -0400
Date: Wed, 6 Jun 2007 15:05:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Wright <chrisw@sous-sol.org>, gregkh@suse.de,
       akpm@linux-foundation.org, htejun@gmail.com,
       linux-kernel@vger.kernel.org, maneesh@in.ibm.com, sandeen@redhat.com,
       stable@kernel.org
Subject: Re: [stable] patch
	sysfs-store-sysfs-inode-nrs-in-s_ino-to-avoid-readdir-oopses.patch
	queued to -stable tree
Message-ID: <20070606220504.GT3723@sequoia.sous-sol.org>
References: <46525648.8050807@sandeen.net> <20070606194950.D357EE83785@imap.suse.de> <20070606213543.GS3723@sequoia.sous-sol.org> <466728D6.30200@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466728D6.30200@sandeen.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Sandeen (sandeen@sandeen.net) wrote:
> Well, my backport of Tejun's patch explicitly doesn't use ida for just
> that reason...
> 
> It uses a simple counter instead (which may give dup inode numbers, but
> I think we have that today, and at least this shouldn't oops...)

Right, my point is the source of the backport is in -mm for maybe as
long as 6 weeks but not in Linus' tree.  I s'pose it's chicken and egg
for the ida code.  I'd prefer to see your patch upstream, and Tejun's
code becomes the ida code plus conversion of the simple counter to ida
at some later point in time.
