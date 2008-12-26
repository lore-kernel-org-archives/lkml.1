Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYLZNON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYLZNON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYLZNN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:13:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbYLZNN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:13:57 -0500
Date: Fri, 26 Dec 2008 11:13:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes
Message-ID: <20081226111324.3fbb804b@caramujo.chehab.org>
In-Reply-To: <20081226090220.GF755@elte.hu>
References: <20081224121252.7560391e@caramujo.chehab.org>
	<20081225081907.GA4628@elte.hu>
	<20081225212459.4c7e31b4@caramujo.chehab.org>
	<20081226090220.GF755@elte.hu>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, 26 Dec 2008 10:02:20 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > Please test the enclosed patch.
> 
> thanks Mauro - i've reverted all my local drivers/media/dvb/ hacks (see 
> them below) and applied your fix, and started testing things. Will let you 
> know if i run into any other kind of build or boot trouble.

Thanks.

I think both dm1105 and dib0700p Kbuild troubles have already been fixed.
However, the opera1/af9005 runtime issue seems to be something different.
I suspect that it is related on having af9005-remote or not. 

Let's see if Luca can help us with this issue.

Cheers,
Mauro
