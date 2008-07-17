Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbYGQPIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbYGQPIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYGQPIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:08:32 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59083 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752956AbYGQPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:08:31 -0400
Date: Thu, 17 Jul 2008 11:08:12 -0400
From: Theodore Tso <tytso@mit.edu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Josef Bacik <jbacik@redhat.com>, Josef Bacik <josef@toxicpanda.com>,
       linux-ext4@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, Johannes Weiner <hannes@saeurebad.de>,
       linux-kernel@vger.kernel.org
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Message-ID: <20080717150812.GU2167@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Josef Bacik <jbacik@redhat.com>, Josef Bacik <josef@toxicpanda.com>,
	linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com,
	Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
References: <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com> <19f34abd0807170620g39ab942bl592ea3fa3fa0dab@mail.gmail.com> <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com> <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com> <20080717135746.GB14133@unused.rdu.redhat.com> <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com> <20080717141333.GC14133@unused.rdu.redhat.com> <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com> <20080717141655.GD14133@unused.rdu.redhat.com> <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard,

How big is the filesystem?  Is there any chance you can make a
compressed e2image of the file?  (This will not include file contents,
but does reveal the names of the file.)  Given the nature of the bug
which you are reporting, it should be safe to scramble the names of
the filenames using the -s option if that would make you feel more
comfortable.

The quick version is:

    e2image -r /dev/loop0 | bzip2 > badfs.e2i.bz2

Then folks like Josef would be able to test your filesystem right
away, instead of asking oyu to test it.

					- Ted
