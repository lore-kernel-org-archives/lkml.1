Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbZHXWzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbZHXWzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZHXWzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:55:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbZHXWzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:55:22 -0400
Date: Mon, 24 Aug 2009 18:55:15 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dm snapshot: implement .iterate_devices
Message-ID: <20090824225514.GA30263@redhat.com>
References: <1251007867-13004-1-git-send-email-snitzer@redhat.com> <20090824141536.30df105c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824141536.30df105c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24 2009 at  5:15pm -0400,
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 23 Aug 2009 02:11:07 -0400
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > This patch implements .iterate_devices for the origin and snapshot
> > targets.  dm-snapshot's lack of .iterate_devices resulted in the
> > inability to properly establish queue_limits for both targets.  
> > 
> > With 4K sector drives: an unfortunate side-effect of not establishing
> > proper limits in either targets' DM device was that IO to the devices
> > would fail even though both had been created without error.
> 
> Does this make the patch a regression fix?

Yes.
 
> > Commit af4874e03ed82f050d5872d8c39ce64bf16b5c38 should have implemented
> > .iterate_devices for dm-snap.c's origin and snapshot targets.
> 
> Please use the form af4874e03ed82f050d5872d8c39ce64bf16b5c38 ("dm
> target:s introduce iterate devices fn") when referring to commits. 
> Because commits might have different IDs in different trees (I think
> that's the reason).

OK, thanks for picking this up.  I believe Alasdair is back from
vacation tomorrow and will be pushing other remaining DM fixes for
2.6.31 final.

