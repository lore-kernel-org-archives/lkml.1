Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYDRQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYDRQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYDRQQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:16:20 -0400
Received: from mail2.shareable.org ([80.68.89.115]:53728 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYDRQQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:16:19 -0400
Date: Fri, 18 Apr 2008 17:15:44 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: szaka@ntfs-3g.org, me@bobcopeland.com, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080418161544.GA31520@shareable.org>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>, szaka@ntfs-3g.org,
	me@bobcopeland.com, hch@infradead.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <20080414004521.GA30489@hash.localnet> <Pine.LNX.4.61.0804181302180.29728@dhcppc2> <20080418115237.GA25089@shareable.org> <E1JmpZz-0005pB-8q@pomaz-ex.szeredi.hu> <20080418125718.GD25089@shareable.org> <E1Jmt23-0006Bq-Kk@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jmt23-0006Bq-Kk@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> > I have been bitten a few times by timeout based caches in the past
> > (NFS and SMB (pre-oplock)).  Simple things like editing a file, then
> > running "ssh compiler-box make" from the editor quietly building
> > incorrect code - and even subsequent make commands don't fix it.  Or
> > when I edit a file, then tell someone I've changed the file - and then
> > they edit the file, and my edits are lost.  Very annoying.  Nobody
> > should build those kind of caches into new software.  :-)
> 
> Oh well, you can turn off caching if it bothers you :)  OTOH it would
> be rather hard (and probably against the point) to try to extend the
> sftp protocol to handle cache coherency.  Sshfs is not meant to be a
> normal filesystem (although some people are trying to use it for home
> directories and such), just a simple way to access remote files.

Oh, I agree.  Violent agreement, they call it :-)

-- Jamie
