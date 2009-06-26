Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZFZRLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZFZRLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZFZRLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:11:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZFZRLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:11:43 -0400
Date: Fri, 26 Jun 2009 13:11:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: mtk.manpages@gmail.com
Cc: jean-noel.cordenner@bull.net, tytso@mit.edu, cmm@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>,
       linux-man <linux-man@vger.kernel.org>, mk <michael.kerrisk@gmail.com>
Subject: Re: MS_I_VERSION added in 2.6.25
Message-ID: <20090626171144.GA2282@infradead.org>
References: <cfd18e0f0906252346v53594fb5u2b2bd630b12ded8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0906252346v53594fb5u2b2bd630b12ded8e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 08:46:34AM +0200, Michael Kerrisk wrote:
> Hi,
> 
> Linux 2.6.25 added the MS_I_VERSION flag for inode versioning. Some
> text on this should be added to the mount(2) man page. Could someone
> of you provide a short description of
> 
> * What inode versions are used for

I don't think it should be documented.  It should never have been a
user-visible option to start with and I'm eventually going to fix that.

The correct way to do this would be a feature flag in the superblock.
