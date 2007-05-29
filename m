Return-Path: <linux-kernel-owner+w=401wt.eu-S1765417AbXE2UI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765417AbXE2UI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbXE2UIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:08:20 -0400
Received: from mail.fieldses.org ([66.93.2.214]:38905 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbXE2UIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:08:19 -0400
Date: Tue, 29 May 2007 16:08:13 -0400
To: David Howells <dhowells@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
Message-ID: <20070529200813.GH6815@fieldses.org>
References: <20070527161252.GA12804@fieldses.org> <20070527022502.GB10867@fieldses.org> <20070526022342.GA20905@fieldses.org> <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com> <7436.1180223730@redhat.com> <18750.1180255870@redhat.com> <28654.1180431281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28654.1180431281@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 10:34:41AM +0100, David Howells wrote:
> I'll need to test the upgrade/downgrade case.  I don't know whether the AFS
> server supports that.  If it doesn't, I can emulate downgrade, but not upgrade
> - not unless I only ever ask it for exclusive locks.
> 
> Lock upgrading is really, really easy to contrive deadlock for.

Any such deadlock is the user's fault.

But, right, I agree that upgrades are probably hard to use correctly.
And that implementing them shouldn't be a priority in the case of AFS.
Just as long as the implementation doesn't completely fall over when
somebody attempts an upgrade.

--b.
