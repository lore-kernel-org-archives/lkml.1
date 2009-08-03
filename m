Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZHCSXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZHCSXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZHCSXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:23:08 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:60443 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbZHCSXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:23:07 -0400
Subject: Re: nfs: __setup_str_nfs_root_setup causes a section type conflict
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, Helge Deller <deller@gmx.de>
In-Reply-To: <200908020010.30459.elendil@planet.nl>
References: <200907311446.33486.elendil@planet.nl>
	 <200908020010.30459.elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 14:23:02 -0400
Message-Id: <1249323782.18161.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 1 sum rcpts/h 6 sum msgs/h 2 total rcpts 965 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8332DE6DC11393CBB9738D6A724901289B8E44E4
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 96 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 00:10 +0200, Frans Pop wrote:
> On Friday 31 July 2009, Frans Pop wrote:
> > While compiling v2.6.31-rc4-294-gf5886c7 for parisc (64-bits) I ran
> > into the following compilation error:
> >
> > /home/fjp/projects/kernel/linux-2.6/fs/nfs/nfsroot.c:403:
> >     error: __setup_str_nfs_root_setup causes a section type conflict
> > make[7]: *** [fs/nfs/nfsroot.o] Error 1
> 


If you do a 'make fs/nfs/nfsroot.i', and then look at the resulting file
fs/nfs/nfsroot.i, what does the line that defines
'__setup_str_nfs_root_setup' look like?

Cheers
  Trond

