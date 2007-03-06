Return-Path: <linux-kernel-owner+w=401wt.eu-S1751121AbXCFUCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbXCFUCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXCFUCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:02:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXCFUCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:02:13 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070306194255.GA5524@martell.zuzino.mipt.ru> 
References: <20070306194255.GA5524@martell.zuzino.mipt.ru>  <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com> 
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() [try #2] 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 06 Mar 2007 20:01:18 +0000
Message-ID: <23156.1173211278@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> wrote:

> >  #if BITS_PER_LONG == 32 && defined(ARCH_HAS_ILOG2_U32)
> 
> There is no such thing except on FRV, where it's redundant.

Redundant in what way?

> 				      CONFIG_ARCH_HAS_ILOG2_U32
> 				      ^^^^^^

Grrr.  Thanks for spotting that.

> >  #elif BITS_PER_LONG == 64 && defined(ARCH_HAS_ILOG2_U64)
> 
> ditto

Ditto.

David
