Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYJ0UyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYJ0UyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJ0UyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:54:00 -0400
Received: from ns.suse.de ([195.135.220.2]:47688 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYJ0Ux7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:53:59 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: tmpfs support of xattrs?
Date: Mon, 27 Oct 2008 21:53:56 +0100
User-Agent: KMail/1.9.9
Cc: Rob MacKinnon <c4blem0nkey@gmail.com>, hpa@zytor.com, hugh@veritas.com,
       linux-kernel@vger.kernel.org, rob.mackinnon@gmail.com,
       Casey Schaufler <casey@schaufler-ca.com>
References: <4902DD98.4090302@gmail.com> <4906211E.8030603@gmail.com> <1225139131.31818.51.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1225139131.31818.51.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810272153.56301.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 October 2008 21:25:31 Stephen Smalley wrote:
> Looks like a bug in Smack's implementation of the inode_listsecurity
> hook to me.  Did you mean to enable Smack in your kernel config?

Yes, there is at least one bug there; this kernel is broken. You may want to 
try booting with a kernel command line option like "security=none", which 
*should* turn smack off.

Andreas
