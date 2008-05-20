Return-Path: <linux-kernel-owner+w=401wt.eu-S1764697AbYETXgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764697AbYETXgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763018AbYETXfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:35:53 -0400
Received: from mail2.shareable.org ([80.68.89.115]:52531 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYETXfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:35:52 -0400
Date: Wed, 21 May 2008 00:35:21 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080520233521.GK27853@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <8763tbcrbo.fsf@basil.nowhere.org> <20080519004325.GC8335@mit.edu> <4830E60A.2010809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4830E60A.2010809@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> I'll propose that very close to 0% of users will ever report "having
> barriers off seems to have corrupted my disk on power loss!" even if
> that's exactly what happened.  And it'd be very tricky to identify in a
> post-mortem.

Ooh.

Might it be possible for fsck to identify certain problems as likely
caused by power loss in misordered writes?

If metadata sectors had an update generation number, to be compared
with journal entries, perhaps that would be more feasible.

-- Jamie
