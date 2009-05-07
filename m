Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZEGOoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZEGOoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZEGOoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:44:04 -0400
Received: from thunk.org ([69.25.196.29]:49318 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbZEGOoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:44:03 -0400
Date: Thu, 7 May 2009 10:43:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
	tmpfs
Message-ID: <20090507144353.GA7603@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Kay Sievers <kay.sievers@vrfy.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Jan Blunck <jblunck@suse.de>
References: <1241097822.2516.3.camel@poy> <m1vdodnx8e.fsf@fess.ebiederm.org> <ac3eb2510905070228w5ecb5aa9ob24af17a91d2f231@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510905070228w5ecb5aa9ob24af17a91d2f231@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 11:28:19AM +0200, Kay Sievers wrote:
> On Thu, May 7, 2009 at 10:17, Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > sysfs is slow.
> > udev is slow.
> 
> Everything is "slow" if you want to boot "fast". It's just numbers,
> and this is more about simplicity and reliability, with just the side
> effect that it's the fastest you can do, when you don't want to lose
> current functionality.

How much of this is because, say, udev is using shell scripts as
opposed to C?  If the answer is you lose flexibility when you do it as
shell script fragments, I just spent 30 minutes with Alsadair chewing
on my ear about how udev's use of shell scripts is making dm/LVM's
life hard --- and I'll note that if we solve this problem by bloating
the kernel, you lose flexibility *anyway* since the kernel code will
be in C and not shell scripts.  :-)

						- Ted
