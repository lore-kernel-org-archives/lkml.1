Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404Ab0ACBQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0ACBQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 20:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038Ab0ACBQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 20:16:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:52655 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0ACBQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 20:16:39 -0500
Date: Sun, 3 Jan 2010 02:16:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100103011632.GI5076@nowhere>
References: <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box> <20100102201138.GF5076@nowhere> <20100102210101.GN828@thunk.org> <20100102210653.GH5076@nowhere> <20100102233603.GO828@thunk.org> <4B3FDA38.2070509@nerdbynature.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3FDA38.2070509@nerdbynature.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 03:43:52PM -0800, Christian Kujau wrote:
> tytso@mit.edu wrote on 2010-01-02 15:36 :
>>> Thanks! I'm going to test it now. I've been running a stress test
>>> from Chris Mason which basically checks races on parallel writes/read.
>>
>> Hmm, which test is this?
>
> http://oss.oracle.com/~mason/stress.sh, IIRC.
>
> Christian.


That's it! It's simple script that runs concurrent copies of
a directory and that checks the coherency of the result.

