Return-Path: <linux-kernel-owner+w=401wt.eu-S936165AbZDISji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936165AbZDISji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZDISj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:39:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44558 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZDISj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:39:28 -0400
Date: Thu, 9 Apr 2009 19:39:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
Message-ID: <20090409183909.GF26366@ZenIV.linux.org.uk>
References: <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409181328.GD26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904091120560.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904091120560.4583@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 11:26:49AM -0700, Linus Torvalds wrote:

> I think a lot of SCM's parse diffs internally, so people are still going 
> to have to live with legacy patches.

Frankly, once distributed patch(1) understands those, it becomes a problem
of other SCMs.  And yes, I realize that they might want to do their
internal magic for tracking renames.  Tough - even without that they wouldn't
be worse off than if they got a full "delete this file, create that file"
kind of patch.
