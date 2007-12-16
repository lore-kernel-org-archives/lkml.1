Return-Path: <linux-kernel-owner+w=401wt.eu-S1764309AbXLPWnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764309AbXLPWnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760628AbXLPWnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 17:43:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:35744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760271AbXLPWna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 17:43:30 -0500
From: Neil Brown <neilb@suse.de>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Date: Mon, 17 Dec 2007 09:43:25 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18277.43533.991986.323212@notabene.brown>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 007 of 7] md: Get name for block device in sysfs
In-Reply-To: message from Kay Sievers on Saturday December 15
References: <20071214171950.1308.patches@notabene>
	<1071214062647.1928@suse.de>
	<3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday December 15, kay.sievers@vrfy.org wrote:
> On Dec 14, 2007 7:26 AM, NeilBrown <neilb@suse.de> wrote:
> >
> > Given an fd on a block device, returns a string like
> >
> >         /block/sda/sda1
> >
> > which can be used to find related information in /sys.
....
> 
> As pointed out to when you came up with the idea, we can't do this. A devpath
> is a path to the device and will not necessarily start with "/block" for block
> devices. It may start with "/devices" and can be much longer than
> BDEVNAME_SIZE*2  + 10.


When you say "will not necessarily" can I take that to mean that it
currently does, but it might (will) change??
In that case can we have the patch as it stands and when the path to
block devices in /sys changes, the ioctl can be changed at the same
time to match?

Or are you saying that as the kernel is today, some block devices
appear under /devices/..., in which case could you please give an
example?

Thanks,
NeilBrown
