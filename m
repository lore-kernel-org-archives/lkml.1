Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbYLYFui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbYLYFui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 00:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbYLYFua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 00:50:30 -0500
Received: from ozlabs.org ([203.10.76.45]:35739 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbYLYFu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 00:50:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: linux-next: parsing mem=700M broken
Date: Thu, 25 Dec 2008 16:20:22 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Hugh Dickins <hugh@veritas.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <200812241808.16195.rusty@rustcorp.com.au> <200812241330.29784.ioe-lkml@rameria.de>
In-Reply-To: <200812241330.29784.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812251620.23730.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 December 2008 23:00:27 Ingo Oeser wrote:
> Hello Rusty,
> 
> On Wednesday 24 December 2008, Rusty Russell wrote:
> >  void __init finish_e820_parsing(void)
> >  {
> > +	bool userdef;
> 
> maybe init with userdef = false;

Thanks!  Gcc 3.4 warns about that, gcc 4.1, 4.2 and 4.3 don't.

Strange.
Rusty.
