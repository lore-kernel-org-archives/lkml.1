Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbZLQV6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbZLQV6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZLQV61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:58:27 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:43225 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbZLQV60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:58:26 -0500
Subject: Re: [PATCH -next] nfs: fix ISO C90 warning
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <2375c9f90912170200m12a5310cg90343c5c1081fbb8@mail.gmail.com>
References: <20091215165309.58e98eea.sfr@canb.auug.org.au>
	 <20091216142334.6a0ba115.randy.dunlap@oracle.com>
	 <1261003219.13878.6.camel@localhost>
	 <20091216144700.34b80b4b.randy.dunlap@oracle.com>
	 <alpine.LFD.2.00.0912162355350.2755@localhost.localdomain>
	 <1261004497.13878.9.camel@localhost>
	 <2375c9f90912170200m12a5310cg90343c5c1081fbb8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 16:58:13 -0500
Message-Id: <1261087093.4080.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 1 sum rcpts/h 13 sum msgs/h 2 total rcpts 2086 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 5E9B2F1D1EB5DD9E566CBA5542E9F195F7FBAC5F
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 53 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 18:00 +0800, Américo Wang wrote: 
> Hi,
> Check that currently all usages of RPC_DEBUG are the same,
> we can replace them all.
> 
> What do you think about the attached patch?
> 
> Sorry for attaching it, I have a bad mail environment here.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Doesn't that approach instead lead to a lot of 'unreferenced variable'
warnings in the '#undef RPC_DEBUG' case?

Cheers
  Trond

