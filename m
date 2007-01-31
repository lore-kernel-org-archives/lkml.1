Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXAaAg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXAaAg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 19:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXAaAg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 19:36:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64907 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbXAaAg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 19:36:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: maynardj@us.ibm.com
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 3/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Wed, 31 Jan 2007 01:35:42 +0100
User-Agent: KMail/1.9.5
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net
References: <45BE4ED0.5030808@us.ibm.com> <200701300524.32556.arnd@arndb.de> <45BF64DC.7040506@us.ibm.com>
In-Reply-To: <45BF64DC.7040506@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701310135.43383.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/hlj/hRyVKjuiPFv///CgEfke37n5H7UF1IKn9++Tpg/q7QTGp9q37i20ZvggWu7oELNc3H2sth3cm0uO8N47hIILn58yEVXj6IjxX7Q6gzQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 16:31, Maynard Johnson wrote:
> 
> > On solution would be to move the notify_active flag from ctx->spu
> > into ctx itself, but maybe there are other ways to solve this.
> In an earlier review of this patch, Christopher Hellwig suggested I move 
> the notify_active flag to be a bit in the sched_flags field that's added 
> in his scheduler patch series.  If this patch series will be a available 
> in an "Arnd" tree that we'll be using for our current OProfile 
> development, perhaps I should wait until that time to change this, since 
> the window of vulnerability is quite small.  What do you think?

Sounds good to me.

	Arnd <><
