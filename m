Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYJVFLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYJVFLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYJVFLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:11:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10885 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYJVFLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:11:32 -0400
Date: Tue, 21 Oct 2008 22:11:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: greg@kroah.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for October 21 (printk format warnings)
Message-Id: <20081021221116.dd56244b.randy.dunlap@oracle.com>
In-Reply-To: <20081021.220754.06835391.davem@davemloft.net>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
	<20081021215725.b9c2b941.randy.dunlap@oracle.com>
	<20081022050142.GA11674@kroah.com>
	<20081021.220754.06835391.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 22:07:54 -0700 (PDT) David Miller wrote:

> From: Greg KH <greg@kroah.com>
> Date: Tue, 21 Oct 2008 22:01:42 -0700
> 
> > What's the expected modifier for "size_t" to work on all arches?
> 
> Put "%Z" in front of the output specifier you want to use,
> for example %Zd for decimal and %Zx for hex.
> 
> > Same goes for the result of "size_of()", what should we use there?  Or
> > are we just required to always cast things?
> 
> Sizeof should use the same as above.

I know that Alan recently merged a patch with %Zd instead of %zd,
but the ANSI spec says to use %z, so I thought that we were going with
that moreso than %Z... ??

---
~Randy
