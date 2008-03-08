Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYCHN02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYCHN02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 08:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYCHN0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 08:26:19 -0500
Received: from kumera.dghda.com ([80.68.90.171]:2750 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYCHN0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 08:26:18 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Sat, 8 Mar 2008 13:26:14 +0000
To: Mingming Cao <cmm@us.ibm.com>
Cc: Andreas Dilger <adilger@sun.com>, Duane Griffin <duaneg@dghda.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com
Subject: Re: [PATCH 1/3] jbd2: eliminate duplicated code in revocation table
	init/destroy functions
Message-ID: <20080308132614.GA9412@dastardly.plus.com>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com> <20080307215238.GG1881@webber.adilger.int> <1204934726.14884.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204934726.14884.63.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 04:05:26PM -0800, Mingming Cao wrote:
> > > +	if (!journal->j_revoke_table[0])
> > > +		goto failed_alloc1;
> > > +	if (jbd2_journal_init_revoke_table(journal->j_revoke_table[0], hash_size))
> > 
> > (style) wrap at 80 columns.
> > 
> 
> checkpatch.pl catched this...fyi.

It did :)

After following recent LKML threads on this I figured it would probably
be more readable to leave it than fix it. I should have mentioned that,
sorry. Anyway, it is no longer an issue after addressing Andreas'
comments.

> Thanks for reviewing this Andreas.

My thanks, too. I really appreciate the quick and thorough review.

> The patch is already in ext4 candidate patch queue.  FYI.

If I can do anything to simplify updating it with revised versions then
let me know.

> Mingming

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
