Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbXDPDA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbXDPDA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXDPDAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:00:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36236 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754336AbXDPDAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:00:55 -0400
Date: Mon, 16 Apr 2007 13:00:35 +1000
From: David Chinner <dgc@sgi.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Neil Brown <neilb@suse.de>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070416030035.GX32602149@melbourne.sgi.com>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <17952.5537.364603.419364@notabene.brown> <m3odlqiy3b.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3odlqiy3b.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 08:56:40PM +0200, Krzysztof Halasa wrote:
> Neil Brown <neilb@suse.de> writes:
> 
> > What, specifically, is there in ZFS that you want to use in Linux?
> > There is lots of interesting stuff in there, but which bit has caught
> > your attention?  It is possible that that functionality can be
> > incorporated into Linux without trying to clone or copy ZFS.
> 
> Filesystem block hashes (checksums) and in-fs redundancy (using the
> hashes to determine which copy of data is correct in case of
> corruption). It would mean multi-device filesystem.

Yup - multidevice support in XFS is something I'm working on
at the moment. There's many nice features that multi-device
filesystems can take advantage of (different geomteries,
multiple journals, internal RAID, redundancy, partially
online/offline filesystems, partial filesystem repair, etc).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
