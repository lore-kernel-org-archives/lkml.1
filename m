Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYGQPlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYGQPlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbYGQPlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:41:15 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34529 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754498AbYGQPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:41:13 -0400
Date: Thu, 17 Jul 2008 11:40:51 -0400
From: Theodore Tso <tytso@mit.edu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Josef Bacik <jbacik@redhat.com>, Josef Bacik <josef@toxicpanda.com>,
       linux-ext4@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, Johannes Weiner <hannes@saeurebad.de>,
       linux-kernel@vger.kernel.org
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer
	dereference at 0000000c
Message-ID: <20080717154051.GW2167@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Josef Bacik <jbacik@redhat.com>, Josef Bacik <josef@toxicpanda.com>,
	linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com,
	Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
References: <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com> <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com> <20080717135746.GB14133@unused.rdu.redhat.com> <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com> <20080717141333.GC14133@unused.rdu.redhat.com> <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com> <20080717141655.GD14133@unused.rdu.redhat.com> <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com> <20080717150812.GU2167@mit.edu> <19f34abd0807170816p4788a352qc35b42fd7647d00f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807170816p4788a352qc35b42fd7647d00f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 05:16:39PM +0200, Vegard Nossum wrote:
> Is there a way to override the
> 
>     "Errors behavior:          Continue"
> 
> information which is present in the filesystem?

Yep:

tune2fs -e remount-ro /dev/XXXX

I should probably make the default configurable, and not "continue"....

  	 	       	   	   		     - Ted
