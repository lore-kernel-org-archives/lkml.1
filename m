Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXKEWmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXKEWmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXKEWmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:42:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbXKEWml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:42:41 -0500
Date: Mon, 5 Nov 2007 14:42:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: davem@davemloft.net, jgarzik@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
In-Reply-To: <20071105222846.GA32090@suse.de>
Message-ID: <alpine.LFD.0.999.0711051438500.15101@woody.linux-foundation.org>
References: <20071105215601.GA4612@kroah.com>
 <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
 <alpine.LFD.0.999.0711051414120.15101@woody.linux-foundation.org>
 <20071105222846.GA32090@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, Greg KH wrote:
> 
> I'm guessing that David is referring to a commit in his tree, not in
> yours yet.

Well, I suspect that David referred to a commit that he just sent by 
email. Which obviously will have a *different* commit ID once you commit 
it - so it probably made sense in his tree, but not once he exported it 
as an email instead of syncing with git natively. 

I also suspect that the whole series was re-ordered in email (or by you 
reading/applying them in a different order). Since now the revert of the 
"disable MSI" happens *before* the patch that looks like it will fix the 
issue.

So I think David also probably didn't number his patches.

			Linus
