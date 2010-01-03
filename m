Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559Ab0ACCFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0ACCFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 21:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038Ab0ACCFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 21:05:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61460 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0ACCFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 21:05:18 -0500
Date: Sat, 2 Jan 2010 18:05:13 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
In-Reply-To: <20100103015208.GJ5076@nowhere>
Message-ID: <alpine.DEB.2.01.1001021800450.3483@bogon.housecafe.de>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box>
 <20100102201138.GF5076@nowhere> <20100102210101.GN828@thunk.org> <20100102210653.GH5076@nowhere> <20100102233603.GO828@thunk.org> <20100103015208.GJ5076@nowhere>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18O5pLuORaZay0q1SqlyMtxTGfgc05QdyYhUMe
 Ps4Cf+E0Y1gKaVGaa1icY41uhpRKOIVAr1YHo6yn2LVAeE+39H
 oStJsiXyCqLdpB77tvWZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jan 2010 at 02:52, Frederic Weisbecker wrote:
> [: 53: ==: unexpected operator
> common.rc: Error: $TEST_DEV (/dev/sda3) is not a MOUNTED xfs filesystem

Yeah, I'm playing around with xfstests as well, but apparently they're 
assuming !/bin/sh will be run under /bin/bash, which is not always the 
case. A short fix is to link /bin/sh to /bin/bash, but perhaps some of the 
tests can be tweaked to run under /bin/sh as well.

> I'm not sure how I can run these tests on a non-xfs partitions.
> I must be missing something.

I haven't found an easy way to do this yet without rewriting a few 
routines (mkfs, mount, etc...). As Ted is already using xfstests for 
btrfs, ext4, maybe he wants to share his magic? :-)

Christian.
-- 
BOFH excuse #47:

Complete Transient Lockout
