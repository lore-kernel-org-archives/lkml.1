Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZIPQ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZIPQ2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbZIPQ2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:28:34 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:56487 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752473AbZIPQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:28:33 -0400
Date: Wed, 16 Sep 2009 12:26:04 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Jeff Layton <jlayton@redhat.com>
cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
In-Reply-To: <20090915183405.2797b05e@tlielax.poochiereds.net>
Message-ID: <alpine.DEB.1.10.0909161224420.21599@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1> <20090905071052.50501826@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1> <20090909125352.1c7b57d2@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
 <20090909132039.1ca47cd4@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091327370.32067@V090114053VZO-1> <20090909140257.35ede0cc@tlielax.poochiereds.net> <alpine.DEB.1.10.0909091724200.15746@V090114053VZO-1> <20090909205548.4858b524@zanovar.poochiereds.net>
 <alpine.DEB.1.10.0909101419310.29762@V090114053VZO-1> <20090910153347.2f2616e8@barsoom.rdu.redhat.com> <alpine.DEB.1.10.0909101541460.28418@V090114053VZO-1> <20090910165757.43b77874@tlielax.poochiereds.net> <alpine.DEB.1.10.0909101721180.27669@V090114053VZO-1>
 <20090910201932.5b8356e2@tlielax.poochiereds.net> <alpine.DEB.1.10.0909141600300.24371@V090114053VZO-1> <20090915183405.2797b05e@tlielax.poochiereds.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, Jeff Layton wrote:

> Yow, that version of mount.cifs is really old. I wonder if it may be
> passing bad mount options to the kernel? Might be interesting to strace
> that. Something like:
>
> # strace -f -s 256 -e mount mount -t cifs //chiprodfs2/company /mnt -ouser=clameter,domain=xxx
>
> ...it'll probably have a cleartext password in it so you might want to
> doctor the options a bit before sending along if you do.
>
> Alternately, you might just want to try a newer version of mount.cifs
> and see whether that fixes this.

Tried a newer version of mount.cifs without any change.

> > I cannot mount the clameter dir on the 32 bit box. Hangs. So I will mount
> > /company.
> >
>
> Actually, the trace of a hanging mount would probably be interesting.
>
> Does the 32-bit capture that you sent represent a mount attempt that
> hung? Or was it successful?

No it was successful.

> What's the "devname" that you're giving to the mount command for the
> "clameter" dir? If there's more than 1 path component after the
> hostname, then the problem may be in the old version of mount.cifs.
> Some of them had broken handling for path prefixes.

its //machinename/company/clameter

So two components.

