Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYJNC6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYJNC6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbYJNC6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:58:21 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44033 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755262AbYJNC6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:58:20 -0400
Date: Mon, 13 Oct 2008 22:58:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, adilger@sun.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 4/4] jbd2: don't dirty original metadata buffer on abort
Message-ID: <20081014025814.GB9332@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, jack@suse.cz
References: <48EF168A.4000705@hitachi.com> <48EF1A11.9090303@hitachi.com> <20081013203641.GA6469@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013203641.GA6469@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 01:36:42PM -0700, Joel Becker wrote:
> > This patch prevents original metadata buffers from being dirtied
> > on abort by clearing BH_JBDDirty flag from those buffers.  Thus,
> > no metadata buffers are written to the filesystem without journaling.
> 
> 	It's not my place to Ack such patches, but I noticed this bug
> during Plumbers, and Eric and Andreas pointed me to this patch, which
> fixes it quite nicely.  Just $0.02 :-)

Already pushed to Linus, and in mainline.  :-)

							- Ted
