Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXHVD16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXHVD16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbXHVD1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:27:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53967 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421AbXHVD1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:27:48 -0400
X-Sasl-enc: 76AZo10+ZFugP05mH75iRq8b6m7egHfVTnpR2tR7qzKB 1187753267
Subject: Re: [autofs] [PATCH] autofs4: reinstate negatitive timeout of
	mount fails
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1187751415.3899.9.camel@raven.themaw.net>
References: <1187688369.3318.12.camel@raven.themaw.net>
	 <20070821131551.4026fb96.akpm@linux-foundation.org>
	 <1187751415.3899.9.camel@raven.themaw.net>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 11:27:42 +0800
Message-Id: <1187753262.3899.13.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 10:56 +0800, Ian Kent wrote:
> On Tue, 2007-08-21 at 13:15 -0700, Andrew Morton wrote:
> > 
> > It seems to use a lot of list_for_each[_safe] which could
> > have been coded as list_for_each_entry[_safe], btw.
> 
> Mmm .. good point. I've not noticed the list_for_each_entry* macros.

A good idea but that change would cover more than just this patch so I'd
rather leave the patch as is and submit a cleanup patch to cover this
later.

Ian


