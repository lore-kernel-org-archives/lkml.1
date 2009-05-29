Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZE2Bcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZE2Bcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZE2BcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:32:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:52224 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZE2BcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:32:23 -0400
Date: Thu, 28 May 2009 18:27:48 -0700
From: Greg KH <gregkh@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Avi Kivity <avi@redhat.com>,
       George Dunlap <George.Dunlap@eu.citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Kurt C. Hackel" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@citrix.com>, xen-users@lists.xensource.com,
       Ky Srinivasan <ksrinivasan@novell.com>,
       Eric Anderson <EAnderson@novell.com>,
       Wim Coekaerts <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: Xen is a feature
Message-ID: <20090529012748.GA12067@suse.de>
References: <4A1C3453.6080402@redhat.com> <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1F302E.8030501@goop.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 05:45:34PM -0700, Jeremy Fitzhardinge wrote:
> Mozilla and Debian are hosted on Xen systems.

A tiny data point about these domains.  They are hosted by osuosl.org,
which uses xen systems running with the current dom0 patch set.  Because
those patches are out-of-tree, they have a hard time updating kernel
versions, and generally lag kernel.org releases by a lot, which is not
always a good thing.

So getting the dom0 patches into mainline will make their lives much
easier, and more secure.

thanks,

greg k-h
