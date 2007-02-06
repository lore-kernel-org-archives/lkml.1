Return-Path: <linux-kernel-owner+w=401wt.eu-S965466AbXBFCa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965466AbXBFCa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 21:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965464AbXBFCa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 21:30:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:44476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965444AbXBFCa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 21:30:57 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Mon, 5 Feb 2007 18:30:43 -0800
User-Agent: KMail/1.9.5
Cc: Casey Schaufler <casey@schaufler-ca.com>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <101270.11571.qm@web36602.mail.mud.yahoo.com> <20070205195058.GT10475@sequoia.sous-sol.org>
In-Reply-To: <20070205195058.GT10475@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051830.43560.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 11:50, Chris Wright wrote:
> This kind of change (or perhaps straight to struct path) is definitely
> needed from AA. 

I tried struct path; in terms of code size it doesn't seem worth it. We could 
get identical code out of it as if we were passing the dentry and vfsmount 
individually, with somewhat slimmer looking interfaces, but then we'd have to 
create temporary struct path objects in a few places, and accessing either 
object would become a bit more verbose (path.dentry instead of dentry, etc.)

See the following thread on linux-kernel, Message-ID 
200702031425.38054.agruen@suse.de:

  [RFC] Pack the vfsmount and dentry in nameidata into a struct path

Thanks,
Andreas
