Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZLROjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZLROjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZLROjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:39:44 -0500
Received: from khc.piap.pl ([195.187.100.11]:35617 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbZLROjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:39:43 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
	<200912181455.34664.bzolnier@gmail.com>
Date: Fri, 18 Dec 2009 15:39:40 +0100
In-Reply-To: <200912181455.34664.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Fri, 18 Dec 2009 14:55:34 +0100")
Message-ID: <m3eims1h3n.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

>> 	set_le_ih_k_offset(ih,
>> 			   le_ih_k_offset(ih) +
>> 			   (tb->
>> 			    lbytes <<
>> 			    (is_indirect_le_ih
>> 			     (ih) ? tb->tb_sb->
>> 			     s_blocksize_bits -
>> 			     UNFM_P_SHIFT :
>> 			     0)));

> Firstly what kind of a function parameter is that:

It's hard to tell without unmangling the line first :-)
-- 
Krzysztof Halasa
