Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbXCMVQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbXCMVQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933365AbXCMVQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:16:12 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:48086 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbXCMVQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:16:11 -0400
Date: Tue, 13 Mar 2007 14:17:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: JanuGerman <doublemalam@yahoo.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: LSM Stacking
Message-ID: <20070313211703.GQ6602@sequoia.sous-sol.org>
References: <20070313074439.22410.qmail@web86912.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313074439.22410.qmail@web86912.mail.ukl.yahoo.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* JanuGerman (doublemalam@yahoo.co.uk) wrote:
> My question is that whether root_plug.c security
> module is stacked with the SELinux security module or
> not. If root_plug.c is stacked, where i can find the
> code which handles the stacking of SELinux and
> root_plug.c within the kernel.

Look at rootplug_init where it does mod_reg_security.
If you have SELinux builtin, and subsequently register
rootplug, it will stack under SELinux.  Typically this
isn't the case (typically stacks with capabilities).

> Further, any pointer to stacking mechansims in Linux
> 2.6.* kernel will be highly appreciated.

Check the linux-security-module archives.  This issue
has been discussed quite extensively numerous times
there.

thanks,
-chris
