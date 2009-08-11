Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZHKSJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZHKSJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZHKSJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:09:49 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:34062 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZHKSJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:09:48 -0400
Subject: Re: NULL pointer dereference in __put_nfs_open_context()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1250010984.30628.15.camel@pc1117.cambridge.arm.com>
References: <1249990719.27150.52.camel@pc1117.cambridge.arm.com>
	 <1249995530.12218.3.camel@heimdal.trondhjem.org>
	 <1250010984.30628.15.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 14:09:45 -0400
Message-Id: <1250014185.26580.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 1021 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 60E6349AD1BBB937E38C3CC35169B7E904F6A699
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 116 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 18:16 +0100, Catalin Marinas wrote:
> On Tue, 2009-08-11 at 08:58 -0400, Trond Myklebust wrote:
> > How about the following instead? This patch gets rid of those
> > nfs_open_context references altogether...
> 
> It fixes the kernel oops.
> 
> Thanks.

Can I mark that as a Tested-by? :-)

Cheers
  Trond

