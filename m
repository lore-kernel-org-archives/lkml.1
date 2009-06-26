Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbZFZSqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbZFZSqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZFZSqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:46:12 -0400
Received: from THUNK.ORG ([69.25.196.29]:36188 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZFZSqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:46:11 -0400
Date: Fri, 26 Jun 2009 14:45:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: mtk.manpages@gmail.com, jean-noel.cordenner@bull.net, cmm@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>,
       linux-man <linux-man@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
Subject: Re: MS_I_VERSION added in 2.6.25
Message-ID: <20090626184522.GF7182@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>, mtk.manpages@gmail.com,
	jean-noel.cordenner@bull.net, cmm@us.ibm.com,
	lkml <linux-kernel@vger.kernel.org>,
	linux-man <linux-man@vger.kernel.org>,
	mk <michael.kerrisk@gmail.com>
References: <cfd18e0f0906252346v53594fb5u2b2bd630b12ded8e@mail.gmail.com> <20090626171144.GA2282@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626171144.GA2282@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 01:11:44PM -0400, Christoph Hellwig wrote:
> On Fri, Jun 26, 2009 at 08:46:34AM +0200, Michael Kerrisk wrote:
> > Hi,
> > 
> > Linux 2.6.25 added the MS_I_VERSION flag for inode versioning. Some
> > text on this should be added to the mount(2) man page. Could someone
> > of you provide a short description of
> > 
> > * What inode versions are used for
> 
> I don't think it should be documented.  It should never have been a
> user-visible option to start with and I'm eventually going to fix that.
> 
> The correct way to do this would be a feature flag in the superblock.

Agreed, the intention was this was something which NFSv4 would request
of the filesystem, by flipping a bit.  I don't see a good reason why a
user would ever want to explicit request 64-bit version numbers, since
they're not even visible to userspace.

						- Ted
