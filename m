Return-Path: <linux-kernel-owner+w=401wt.eu-S965853AbXDGNyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965853AbXDGNyu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 09:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965849AbXDGNyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 09:54:50 -0400
Received: from cobalt0.barnhard.net ([216.181.81.129]:50515 "EHLO
	cobalt0.barnhard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965851AbXDGNyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 09:54:45 -0400
X-Greylist: delayed 3311 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2007 09:54:45 EDT
Date: Sat, 7 Apr 2007 13:59:14 +0100
From: Dale Amon <amon@vnl.com>
To: johnrobertbanks@fastmail.fm
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Message-ID: <20070407125914.GA31074@vnl.com>
Mail-Followup-To: Dale Amon <amon@vnl.com>, johnrobertbanks@fastmail.fm,
	Jan Harkes <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux, the choice of a GNU generation
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan does have a point about bad blocks. A couple years ago
I had a relatively new disk start to go bad on random blocks.
I detected it fairly quickly but did have some data loss.

All the compressed archives which were hit were near
total losses; most other files were at least partially
recoverable.

It is not a matter of your operating system writing
to bad blocks. It is a matter of what happens when the
blocks on which your data sit go bad underneath you.

This issue has also been discussed by people working
with revision control system. If you are archiving
data, how do you know you if your data is still good
unless you actually need it? If you do not know it
is bad, you may well get rid of good copies thinking
you do not need the extras... it does happen.

I would be quite hesitant to go with on disk compression
unless damage was limited to only the bad bits or blocks
and did not propagate through the rest of the file.

Perhaps if everyone used hardware RAID and the RAID
automatically detected a difference due to trashed
data on one disk and flagged the admin with a warning...

BTW: I'm a CMU Alum, so who are you working with Jan?




