Return-Path: <linux-kernel-owner+w=401wt.eu-S1761093AbXH2NvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093AbXH2NvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbXH2NvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:51:12 -0400
Received: from mail.fieldses.org ([66.93.2.214]:46216 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452AbXH2NvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:51:11 -0400
Date: Wed, 29 Aug 2007 09:50:58 -0400
To: Peter Staubach <staubach@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, "Dr. David Alan Gilbert" <linux@treblig.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
Message-ID: <20070829135058.GA13803@fieldses.org>
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey> <20070827214333.GM3118@fieldses.org> <7788.1188328346@turing-police.cc.vt.edu> <46D5767C.9050206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D5767C.9050206@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 09:37:00AM -0400, Peter Staubach wrote:
> There are a lot of ways to discover who is throwing trash
> at your system other than the kernel printing messages.
>
> Tools such as tcpdump and tethereal/wireshark make much better
> tools for this purpose.

The use of printk's and dprintk's in the rpc and nfsd code seems a
little arbitrary in places.  It would be worth grepping for them all,
figuring out how they're currently used, thinking about what we need
them for (to help administrators identify problems?  to help testers
provide debugging information to developers?), and how they might be
abused (remote hosts and unprivileged local users shouldn't be able to
spam the logs), developing some uniform policies, and submitting
patches.

I'm not volunteering, but if someone's interested I think it could be
really helpful, especially if it helps increase the usefulness of bug
reports.

--b.
