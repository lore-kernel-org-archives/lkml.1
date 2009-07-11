Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbZGKWuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbZGKWuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZGKWt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:49:57 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:55610 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZGKWt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:49:56 -0400
Subject: Re: How to monitor Linux NFS client load?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1247352267.7281.2.camel@heimdal.trondhjem.org>
References: <200907112103.27082.arvidjaar@mail.ru>
	 <1247352267.7281.2.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 18:49:52 -0400
Message-Id: <1247352592.7281.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 2 sum rcpts/h 8 sum msgs/h 2 total rcpts 835 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=_URIID_)
X-UiO-Scanned: D5421599BFB128DA03E5DBEBA53C622C787D5C85
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 43 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 18:44 -0400, Trond Myklebust wrote:
> On Sat, 2009-07-11 at 21:03 +0400, Andrey Borzenkov wrote:
> > I am grateful for any hints how can we monitor Linux NFS client and get 
> > real-life numbers of what happens inside. Thank you!
> 
> See the nfs-iostat utility in the nfs-utils package:
> 
> http://git.linux-nfs.org/?p=steved/nfs-utils.git;a=blob;f=tools/nfs-iostat/nfs-iostat.py;h=9626d42609b9485c7fda0c9ef69d698f9fa929fd;hb=HEAD

Oh, and recent versions of 'sar' (from the 'sysstat' package) should
also have support for NFS monitoring.

Trond

