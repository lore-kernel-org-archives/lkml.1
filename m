Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZLRTOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZLRTOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZLRTON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:14:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47327 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbZLRTOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:14:12 -0500
Date: Fri, 18 Dec 2009 19:14:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] anonfd: Make file read-only if fops->write is not
	set
Message-ID: <20091218191404.GJ18217@ZenIV.linux.org.uk>
References: <adaws0k3kd8.fsf@roland-alpha.cisco.com> <20091218061049.GI18217@ZenIV.linux.org.uk> <adak4wk2n97.fsf_-_@roland-alpha.cisco.com> <alpine.DEB.2.00.0912181057040.24513@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912181057040.24513@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 10:59:00AM -0800, Davide Libenzi wrote:
> > so would something like this make sense?  if so I'll send follow-ups
> > converting ia64 / perfmon and infiniband / uverbs to anon_inodes.
> 
> Looks OK to me.

fmode_t calculation looks ugly; I'll update and put into VFS tree
