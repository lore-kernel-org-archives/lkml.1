Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYJHADY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYJHADY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbYJHADO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:03:14 -0400
Received: from nef2.ens.fr ([129.199.96.40]:4620 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbYJHADN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:03:13 -0400
Date: Wed, 8 Oct 2008 02:02:27 +0200
From: Quentin Godfroy <godfroy@clipper.ens.fr>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Message-ID: <20081008000227.GA32052@goelette.ens.fr>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com> <20081006175502.GA12937@mit.edu> <20081007221256.GF15929@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007221256.GF15929@mit.edu>
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Wed, 08 Oct 2008 02:02:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 06:12:56PM -0400, Theodore Tso wrote:
> On Mon, Oct 06, 2008 at 01:55:02PM -0400, Theodore Tso wrote:
> > Here are updates to the two patches I sent you.  The first fixes some
> > printk labels and requires that the debugging dump ioctl be triggered
> > by root; the second fixes the think-o that Eric pointed out earlier
> > this morning.
> 
> Hey Quentin, just wanted to check in and find out if the patches seem
> to be working for you.  They seem to solve the problem on my side; I
> can no longer reproduce the problem.  Is it working for you?

I rebooted, but as I didn't know exactly how to trigger the bug except than
by waiting a few days I was waiting to see.

Do you have an idea about how to trigger the bug?

Regards,
Quentin Godfroy
