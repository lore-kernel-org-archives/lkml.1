Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0BHRZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:25:40 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:44326 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0BHRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:25:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19312.18688.846904.409496@stoffel.org>
Date: Mon, 8 Feb 2010 12:25:20 -0500
From: "John Stoffel" <john@stoffel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Failure to fallback to nfsd-v3 (?)
In-Reply-To: <20100207083103.GA4602@infradead.org>
References: <87pr4h67rf.fsf@devron.myhome.or.jp>
	<20100207041016.GA16865@fieldses.org>
	<8763695u96.fsf@devron.myhome.or.jp>
	<20100207083103.GA4602@infradead.org>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Sun, Feb 07, 2010 at 05:23:49PM +0900, OGAWA Hirofumi wrote:
>> "J. Bruce Fields" <bfields@fieldses.org> writes:
>> 
>> >> And the following commit seems to change the behavior.
>> >> 
>> >> [nfsd4: fix error return when pseudoroot missing]
>> >> f39bde24b275ddc45df1ed835725b609e178c7a0
>> >> 
>> >> Well, anyway, is this a expected behavior change, or something bug?
>> >
>> > It's expected.  I'd recommend turning off nfsv4 on the server (add "-N4"
>> > to the rpc.nfsd commandline) for now.
>> 
>> This looks like the silent user visible change. So, it would be better
>> to add more comment at least in changelog.

Christoph> Or rather it should be fixed.  We should not silently break existing
Christoph> and probably rather common setups.

Hear hear!  NFS should just gracefully fall back as far as it can.  A
slow mount is better than NO mount.  Esp when /home is mounted via
NFS.

John
