Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbYAQKgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbYAQKgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 05:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYAQKg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 05:36:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbYAQKgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 05:36:25 -0500
Date: Thu, 17 Jan 2008 11:34:38 +0100
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
Message-ID: <20080117103438.GC6922@petra.dvoda.cz>
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu> <20080117033309.GX27894@ZenIV.linux.org.uk> <E1JFQEN-0005zn-2N@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JFQEN-0005zn-2N@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:36:11AM +0100, Miklos Szeredi wrote:
> > I'd suggest doing a new file that would *not* try to imitate /etc/mtab.
> > Another thing is, how much of propagation information do we want to
> > be exposed and what do we intend to do with it?
> 
> I think the scheme devised by Ram is basically right.  It shows the
> relationships (slave, peer) and the ID of a master/peer mount.

 Yes. It also shows the full relationship between source and
 destination for bind mounts. Now the /proc/mounts is useless:

  # mount --bind /mnt/test /mnt/test2

  # cat /proc/mounts | grep test
  /dev/root /mnt/test2 ext3 rw,noatime,data=ordered 0 0


> > What do we want to *do* with the information about propagation?
> 
> Just feedback about the state of the thing.  It's very annoying, that
> after setting up propagation, it's impossible to check the result.

 Exactly.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
