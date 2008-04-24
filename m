Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbYDXRbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbYDXRbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYDXRaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:30:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58467 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbYDXRaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:30:52 -0400
Date: Thu, 24 Apr 2008 18:30:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424173013.GA5882@ZenIV.linux.org.uk>
References: <20080424134826.GD15214@ZenIV.linux.org.uk> <200804241725.m3OHPwIs015778@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804241725.m3OHPwIs015778@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 01:25:58PM -0400, Erez Zadok wrote:
> Al, any near-term plans for sb-level "want write" locking as we discussed
> briefly at LSF?  Being able to do so for copyup in unionfs will hopefully
> allow me to prevent concurrent topology changes.

That's pretty close to the top.

> the two directories that need locking.  This rename-locking protocol appears
> to be a special case of the sb-level "want write" idea, right?

Not really - that one doesn't provide any exclusion between writers and
that's what we want from rename/rename.

Take a look at Documentation/filesystems/directory-locking for details
of locking scheme...
