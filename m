Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZKKMRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZKKMRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbZKKMRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:17:24 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:55870 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbZKKMRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:17:23 -0500
Subject: Re: [PATCH 0/2] vfs: ensure that dentries are revalidated on open
 (try #2)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jlayton@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       ebiederm@xmission.com, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       jamie@shareable.org
In-Reply-To: <E1N88eK-0006Im-1F@pomaz-ex.szeredi.hu>
References: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
	 <E1N884c-0006Br-Je@pomaz-ex.szeredi.hu>
	 <1257927970.5138.24.camel@heimdal.trondhjem.org>
	 <E1N88eK-0006Im-1F@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 21:17:19 +0900
Message-Id: <1257941839.2949.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 1 sum rcpts/h 15 sum msgs/h 1 total rcpts 1860 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: B907E63C293F19F31DAF7B04E36440D2600D3503
X-UiO-SPAM-Test: remote_host: 133.93.205.205 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 1 max/h 1 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 09:33 +0100, Miklos Szeredi wrote:
> On Wed, 11 Nov 2009, Trond Myklebust wrote:
> > Aren't both proc symlinks and bind mounts pretty much guaranteed to
> > point to a valid dentry?
> 
> It could for example happen that client bind mounts a regular file,
> then the file is unlinked on the server.  Then the bind mounted dentry
> is no longer valid.

The mountpoint dentry is still supposed to remain valid and accessible
on the client even if the object it points to on the server is invalid.
Otherwise you will not be able to unmount.

Cheers
  Trond

