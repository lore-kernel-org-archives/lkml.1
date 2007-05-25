Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbXEYEO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbXEYEO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXEYEOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:14:20 -0400
Received: from mail.suse.de ([195.135.220.2]:54761 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXEYEOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:14:19 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Fri, 25 May 2007 06:14:08 +0200
User-Agent: KMail/1.9.5
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
In-Reply-To: <309300.41401.qm@web36615.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705250614.08520.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 20:58, Casey Schaufler wrote:
> On Fedora zcat, gzip and gunzip are all links to the same file.
> I can imagine (although it is a bit of a stretch) allowing a set
> of users access to gunzip but not gzip (or the other way around).
> There are probably more sophisticated programs that have different
> behavior based on the name they're invoked by that would provide
> a more compelling arguement, assuming of course that you buy into
> the behavior-based-on-name scheme. What I think I'm suggesting is
> that AppArmor might be useful in addressing the fact that a file
> with multiple hard links is necessarily constrained to have the
> same access control on each of those names. That assumes one
> believes that such behavior is flawwed, and I'm not going to try
> to argue that. The question was about an example, and there is one.

Different policy for different names of the same binary makes more obvious 
sense with chroot environments. That's slightly different from having 
different permissions for the same file within a single profile though.

Thanks,
Andreas
