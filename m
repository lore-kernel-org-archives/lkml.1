Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXCHRmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXCHRmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbXCHRmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:42:05 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:56965 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbXCHRmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:42:04 -0500
Date: Thu, 8 Mar 2007 09:40:36 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
Message-ID: <20070308174036.GF10574@sequoia.sous-sol.org>
References: <1173369812.5981.2.camel@localhost.localdomain> <20070308164132.GL6602@sequoia.sous-sol.org> <20070308170733.GA21099@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308170733.GA21099@sergelap.austin.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serue@us.ibm.com) wrote:
> Are you objecting only to the duplication at the callsites, so that an
> fsnotify-type of consolidation of security and integrity hooks would be
> ok?  Or are you complaining that the security_inode_setxattr and
> integrity_inode_setxattr hooks are too similar anyway, and integrity
> modules should just use some lsm hooks for anything which will be
> authoritative?

It's duplication of callsites with many identical implementations
that's the problem.

> (I could see an argument that integirty subsystem should be purely for
> measuring and hence its hooks should never return a value.  Only hitch
> there is that if integrity subsystem hits ENOMEM it should be able to
> refuse the action...)

Right, that's what I was expecting to see, just the measurement
infrastructure.

thanks,
-chris
