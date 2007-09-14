Return-Path: <linux-kernel-owner+w=401wt.eu-S933037AbXINPnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbXINPnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 11:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbXINPnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 11:43:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58615 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208AbXINPng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 11:43:36 -0400
Date: Sat, 15 Sep 2007 01:43:45 +1000
From: Greg Banks <gnb@sgi.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, nfs@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org, unionfs@filesystems.org,
       linux-cifs-client@lists.samba.org
Subject: Re: [NFS] [PATCH 2/7] NFS: if ATTR_KILL_S*ID bits are set, then skip mode change
Message-ID: <20070914154345.GE25610@sgi.com>
References: <200709041437.l84Eb4lw010007@dantu.rdu.redhat.com> <20070914102545.GF21965@sgi.com> <20070914070258.8fccb40e.jlayton@redhat.com> <20070914130924.GG21965@sgi.com> <20070914093846.7cdd89da.jlayton@redhat.com> <20070914144033.GD25610@sgi.com> <20070914105838.efbfc45e.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914105838.efbfc45e.jlayton@redhat.com>
User-Agent: Mutt/1.5.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 10:58:38AM -0400, Jeff Layton wrote:
> On Sat, 15 Sep 2007 00:40:33 +1000
> Greg Banks <gnb@sgi.com> wrote:
> 
> 
> > Ok, you convinced me.
> 
> Right. When I was first looking at this, I considered some similar
> approaches, but hit roadblocks with all of them. The only real option
> seems to be to leave this to the server, but that does assume that the
> server handles this properly.
> 
> Servers that don't are broken, IMO.

According to what spec?  A quick trip around the machine room shows
that neither Solaris 10 nor Darwin 7.9.0 clobber setuid on write
either.

> If Irix isn't clearing these bits
> on a write then it might be good to see if they can fix that...

I think first you'd have to mount a serious argument that it's broken,
more serious than "it works differently from Linux".

Greg.
-- 
Greg Banks, R&D Software Engineer, SGI Australian Software Group.
Apparently, I'm Bedevere.  Which MPHG character are you?
I don't speak for SGI.
