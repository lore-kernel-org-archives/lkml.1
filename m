Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbYABVcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbYABVcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYABVcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:32:00 -0500
Received: from pat.uio.no ([129.240.10.15]:40702 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbYABVb7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:31:59 -0500
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Adrian Bunk <bunk@kernel.org>
Cc: Diego Calleja <diegocg@gmail.com>, sct@redhat.com,
       akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080102211655.GC15898@does.not.exist>
References: <20080102013218.GO27566@does.not.exist>
	 <20080102192629.28e67241.diegocg@gmail.com>
	 <20080102211655.GC15898@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 02 Jan 2008 16:31:16 -0500
Message-Id: <1199309476.19161.20.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8BIT
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.3, required=5.0, autolearn=disabled, AWL=-0.270)
X-UiO-Scanned: A4356D579F9DF95A40875C7F7D1821DB0CD1AB70
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -2 maxlevel 200 minaction 2 bait 0 mail/h: 417 total 5992897 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 23:16 +0200, Adrian Bunk wrote:
> On Wed, Jan 02, 2008 at 07:26:29PM +0100, Diego Calleja wrote:
> > El Wed, 2 Jan 2008 03:32:18 +0200, Adrian Bunk <bunk@kernel.org> escribió:
> > 
> > > It might make sense to offer ext4 in -mm and even in early -rc kernels, 
> > > but I've already seen people using ext4 simply because a stable kernel 
> > > offered it - and that's definitely not intended.
> > 
> > But isn't that the whole purpose of having ext4 snapshots in the stable kernel - to
> > allow people to try it?
> 
> ext4 has quite an unusual development model for kernel code, other 
> code in the state of ext4 is usually only in -mm and not in stable 
> kernels.

Bullshit... We all do this.

> Stable kernels are mainly meant for usage, not for trying stuff.
> And although I see a point in perhaps shipping some not-yet-perfect 
> device drivers for otherwise unsupported hardware or some
> not-yet-perfect filesystems required for accessing foreign
> (non-Linux) filesystems, I don't see any point in offering a
> WIP Linux-only filesystem in stable kernels.

This breaks with the 2.6.x development model that we've been working
with for several years now. I, for one, do not wish to change that
model.

Trond

