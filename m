Return-Path: <linux-kernel-owner+w=401wt.eu-S933783AbZINUNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbZINUNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933714AbZINUNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:13:00 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:50384 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933710AbZINUMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:12:55 -0400
Date: Mon, 14 Sep 2009 16:10:47 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Jeff Layton <jlayton@redhat.com>
cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
In-Reply-To: <20090910201932.5b8356e2@tlielax.poochiereds.net>
Message-ID: <alpine.DEB.1.10.0909141600300.24371@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1> <20090905071052.50501826@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1> <20090909125352.1c7b57d2@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
 <20090909132039.1ca47cd4@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091327370.32067@V090114053VZO-1> <20090909140257.35ede0cc@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091724200.15746@V090114053VZO-1> <20090909205548.4858b524@zanovar.poochiereds.net>
 <alpine.DEB.1.10.0909101419310.29762@V090114053VZO-1> <20090910153347.2f2616e8@barsoom.rdu.redhat.com> <alpine.DEB.1.10.0909101541460.28418@V090114053VZO-1> <20090910165757.43b77874@tlielax.poochiereds.net> <alpine.DEB.1.10.0909101721180.27669@V090114053VZO-1>
 <20090910201932.5b8356e2@tlielax.poochiereds.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009, Jeff Layton wrote:

> In any case, I think we need to look closely at what's happening at
> mount time. First, I'll need some other info:
>
> 1) output of "/sbin/mount.cifs -V" from both machines

The 32 bit machine

#/sbin/mount.cifs -V
mount.cifs version: 1.5

mount -t cifs //chiprodfs2/company /mnt -ouser=clameter,domain=xxx

64 bit machine

$ /sbin/mount.cifs -V
mount.cifs version: 1.12-3.4.0

mount -t cifs //chiprodfs2/company /mnt -ouser=clameter,domain=w2k

> 3) wire captures from mount attempts on both machines. Try to mount the
> "clameter" dir on both boxes and do captures of each attempt. Maybe
> this time use -s 0 with tcpdump so we get all of the traffic.

I cannot mount the clameter dir on the 32 bit box. Hangs. So I will mount
/company.

> There may be crackable password hashes in the captures, so you may want
> to send them to me privately and not cc the list.

Ok will follow.

