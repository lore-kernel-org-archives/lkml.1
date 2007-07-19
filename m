Return-Path: <linux-kernel-owner+w=401wt.eu-S940674AbXGSRY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940674AbXGSRY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936432AbXGSRYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:24:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132AbXGSRYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:24:01 -0400
Date: Thu, 19 Jul 2007 19:22:43 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Bodo Eggert <7eggert@gmx.de>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
In-Reply-To: <1184856088.17338.513.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Pine.LNX.4.58.0707191921230.3442@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>  <200707181754.05560.rob@landley.net>
  <Pine.LNX.4.58.0707191442440.2138@be1.lrz> <1184856088.17338.513.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+pBpVgKKrf1rVGe66sHG14QM0xT6yGg/IPMzR
 I+jyLwSQe3iahfLiudEKUfu0TgM3UivhG2ZOGXyv4Zn+9lduSP
 r4gqhwXxqqiKbdVX1UdVg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Stephen Smalley wrote:

> Not wanting to get into any flamewars here about selinux, but just FYI:
> security_sb_post_mountroot is obsolete and can be removed without harm
> to selinux; it is a leftover of selinux before we moved the initial
> policy load to userspace.  These days, initial policy load is done
> by /sbin/init in most distros that support selinux, although I'd prefer
> to do it earlier from the initramfs (the Fedora folks didn't like that
> idea though at the time, so /sbin/init got patched instead - but that
> was back in 2003, so maybe things have changed).

Thanks, that information will help a lot.
-- 
Funny quotes:
7. You have the right to remain silent. Anything you say will be misquoted,
   then used against you.
