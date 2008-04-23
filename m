Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbYDWFpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbYDWFpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYDWFpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:45:06 -0400
Received: from sous-sol.org ([216.99.217.87]:53133 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYDWFpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:45:05 -0400
Date: Tue, 22 Apr 2008 22:37:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
Message-ID: <20080423053726.GF3861@localhost.localdomain>
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480DC80F.3060403@ak.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KaiGai Kohei (kaigai@ak.jp.nec.com) wrote:
> [PATCH 2/3] exporting capability name/code pairs
> 
> This patch enables to export code/name pairs of capabilities the running
> kernel supported.
> 
> A newer kernel sometimes adds new capabilities, like CAP_MAC_ADMIN
> at 2.6.25. However, we have no interface to disclose what capabilities
> are supported on the running kernel. Thus, we have to maintain libcap
> version in appropriate one synchronously.
> 
> This patch enables libcap to collect the list of capabilities at run time,
> and provide them for users. It helps to improve portability of library.
> 
> It exports these information as regular files under /sys/kernel/capability.
> The numeric node exports its name, the symbolic node exports its code.

I do not understand why this is necessary.  The capability bits are an ABI
that shouldn't change in a non-backward compat way (i.e. only additions).

We typically don't export strings <-> number conversions for constants.
I know you've explained this a few times before, but it still seems to me
like a userspace only problem.  What can userspace do with a capability
it does not know about?

thanks,
-chris
