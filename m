Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYJNM0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYJNM0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbYJNMZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:25:55 -0400
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:43943 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbYJNMZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:25:54 -0400
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 08:25:54 EDT
Date: Tue, 14 Oct 2008 15:16:43 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: Miklos Szeredi <miklos@szeredi.hu>
cc: tj@kernel.org, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCHSET] FUSE: extend FUSE to support more
 operations
In-Reply-To: <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.61.0810141512570.14752@dhcppc2>
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
 <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Oct 2008, Miklos Szeredi wrote:

> I still got qualms about this ioctl thing.  One is the security
> aspect, but that could be dealt with.  The other is that I really
> really don't want people to start implementing new custom ioctls for
> their filesystems, as I think that way lies madness.  We could limit
> ioctls to CUSE and that would be fine with me.  Or for non-CUSE users
> we could enforce the "standard" format where the type and length is
> encoded in the command number.

Is this enough to support the most useful/requested file system ioctls, 
like FIEMAP?

Thanks,
	   Szaka

-- 
NTFS-3G:  http://ntfs-3g.org


