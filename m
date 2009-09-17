Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZIQJOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZIQJOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbZIQJOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:14:30 -0400
Received: from gate.in-addr.de ([212.8.193.158]:52164 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757331AbZIQJO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:14:29 -0400
X-Greylist: delayed 1439 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 05:14:29 EDT
Date: Thu, 17 Sep 2009 10:50:03 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Christoph Hellwig <hch@infradead.org>,
       Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090917085003.GR13069@suse.de>
References: <200909151645.14256.philipp.reisner@linbit.com> <20090915231931.GB7636@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090915231931.GB7636@infradead.org>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-09-15T19:19:31, Christoph Hellwig <hch@infradead.org> wrote:

Hi Christoph,

> > It has been discussed and reviewed on the list since March,
> > and Andrew has asked us to send a pull request for 2.6.32-rc1.
> 
> The last thing we need is another bloody raid-reimplementation, coupled
> with a propritary on the wire protocol.  NACK as far as I am concerned.

You know that several RAID implementations are my primary pet peeve, and
I would just love to agree with you here. However, reality isn't that
black-xor-white.

In reality, a significant number of deployments using this
implementation exist already. There is no alternative for them yet, much
less one which would allow them an online migration.  There might be one
day, if dm-replicator takes off, and the RAID engines between
md/dm/btrfs/drbd/dm-replicator etc get unified, but as it stands today,
this doesn't exist.

drbd is stable, the code has been significantly cleaned up during the
LKML dialogue so far. It is very well maintained and supported.

As a mid- to long-term goal, the unification should be pursued, and I
know that Lars Ellenberg _is_ talking with Heinz about dm-replicator and
that Neil/Heinz/Alasdair are also occasionally talking with each other.

Until this has happened though, the plurality of solutions exist.

drbd meets the technical/code quality requirements for merging; the
argument that we should only have one RAID implementation is valid, but
"should" is overruled by the normative power of facts.

Putting the burden of converging our RAID implementations on drbd is a bit
too much; this argument would have made sense when dm-raid* was merged,
but today, we're already carrying several.

Similarly, we support FCoE, AoE, iSCSI, nbd, and if someone proposed
iSCSI-over-USB, I'm sure we would merge even that abdomination. (I hope
I didn't give anyone ideas!) We also have several file systems.


Regards,
    Lars

-- 
Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

