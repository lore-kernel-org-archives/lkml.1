Return-Path: <linux-kernel-owner+w=401wt.eu-S933434AbXBETnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbXBETnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933424AbXBETm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:42:59 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55999 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933427AbXBETm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:42:58 -0500
Date: Mon, 5 Feb 2007 11:50:58 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, agruen@suse.de
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070205195058.GT10475@sequoia.sous-sol.org>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <101270.11571.qm@web36602.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <101270.11571.qm@web36602.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Casey Schaufler (casey@schaufler-ca.com) wrote:
> > They are being posted now as a request for comment. 
> > Presently the AppArmor
> > code - being a user of the LSM interface - does not
> > receive the vfsmount 
> > correspoding to an operation and has to employ
> > convoluted and slow mechanisms 
> > in an attempt to determine the vfsmount which are
> > error prone.
> 
> Would it be possible for you to describe those
> methods? Perhaps there is a better way to go
> about getting the information you need without
> introducing this level of change.

It's not really worth describing, since it's not acceptable in upstream.
But it basically cycles vfsmnts and looks for matches to guess which
part of the tree the dentry is in.  This kind of change (or perhaps
straight to struct path) is definitely needed from AA.
