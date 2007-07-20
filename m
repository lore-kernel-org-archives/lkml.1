Return-Path: <linux-kernel-owner+w=401wt.eu-S939160AbXGTIii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939160AbXGTIii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932155AbXGTIiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:38:18 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:46935 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762610AbXGTIiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:38:14 -0400
Date: Fri, 20 Jul 2007 17:37:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] m68k: use .text.head
Message-ID: <20070720083754.GA26399@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
	linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <E1IBjEq-0004ks-5L@ZenIV.linux.org.uk> <20070720080623.GB15534@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720080623.GB15534@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:06:24AM +0200, Heiko Carstens wrote:
> On Fri, Jul 20, 2007 at 04:33:08AM +0100, Al Viro wrote:
> > 
> > i.e. tell modpost that entry point code (that has to be outside
> > of .init.text for external reasons) is OK to refer to .init.*
> > 
> I was wondering how to "fix" this on s390 since we have the same issue.
> So I'll do it the same way here. Thanks.

Likewise for sh/sh64. Perhaps this should be reposted to linux-arch ;-)
