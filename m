Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZLRO23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZLRO23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbZLRO2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:28:17 -0500
Received: from khc.piap.pl ([195.187.100.11]:34796 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZLRO2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:28:15 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Valdis.Kletnieks@vt.edu
Cc: Mikulas Patocka <mpatocka@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
Date: Fri, 18 Dec 2009 15:28:12 +0100
In-Reply-To: <24653.1261110557@localhost> (Valdis Kletnieks's message of "Thu,
	17 Dec 2009 23:29:17 -0500")
Message-ID: <m3my1g1hmr.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
> continuation line, it's probably in its rights to whinge.

Yes, but don't make it a hard error, only a suggestion that something is
probably really wrong.

> fs/reisersfs/do_balan.c, lines 460-477 (note: 3 leading tabs elided)
>
> 				leaf_paste_entries(&bi,
> 						   n +
> 						   item_pos
> 						   -
> 						   ret_val,
> 						   l_pos_in_item,
> 						   1,
> 						   (struct
> 						    reiserfs_de_head
> 						    *)
> 						   body,
> 						   body
> 						   +
> 						   DEH_SIZE,
> 						   tb->
> 						   insert_size
> 						   [0]
> 				    );
>
> Yes, that used to be 24 more columns to the right.  Gaak.

Precisely. It's a clear show of the damage hard rules like that do.
I can't even tell how the code should be fixed and if the simple merging
would do, since I can't really imagine how it would look like :-)
-- 
Krzysztof Halasa
