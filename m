Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZGUTyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZGUTyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZGUTyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:54:41 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:36907 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbZGUTyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:54:40 -0400
Subject: Re: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frans Pop <elendil@planet.nl>
Cc: greearb@candelatech.com, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
In-Reply-To: <200907212123.08790.elendil@planet.nl>
References: <4A64EB1F.4000602@candelatech.com>
	 <1248178527.5222.0.camel@heimdal.trondhjem.org>
	 <4A65F184.5060802@candelatech.com>
	 <1248196339.21343.8.camel@heimdal.trondhjem.org>
	 <4A65FCB2.6080903@candelatech.com>
	 <1248199140.21343.17.camel@heimdal.trondhjem.org>
	 <4A660295.9020807@candelatech.com> <4A660295.9020807@candelatech.com>
	 <1248200897.21343.19.camel@heimdal.trondhjem.org>
	 <200907212123.08790.elendil@planet.nl>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 15:54:36 -0400
Message-Id: <1248206076.21343.30.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 9 sum msgs/h 2 total rcpts 919 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: EB09C9F725D398AB058B38EAB7EED408FEEED84B
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 79 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 21:23 +0200, Frans Pop wrote:
> Trond Myklebust wrote:
> > Ah... You have NFS_V4_1 enabled despite the Kconfig warning... Does the
> > bug occur when you turn this off too?
> 
> Eh, no. In my case both client and server are 2.6.30 which did not yet 
> have NFS_V4_1 (and in all my .31 configs I did disable it).

...and you are seeing the state manager running when you try to mount an
NFSv4 partition using the 2.6.30 client?

Trond

