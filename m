Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYCVKQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYCVKQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 06:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYCVKQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 06:16:36 -0400
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:45060
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702AbYCVKQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 06:16:35 -0400
X-Authority-Analysis: v=1.0 c=1 a=bF9fCXb2cRsA:10 a=X1qYviOpUwoHJc9QY0YA:9
 a=WxVMAdhJ5WaiPTq4iAyRo_811QAA:4 a=si9q_4b84H0A:10 a=WuK_CZDBSqoA:10
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
From: Nicholas Miell <nmiell@comcast.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080322091001.GA7264@one.firstfloor.org>
References: <20080318104437.966c10ec.akpm@linux-foundation.org>
	 <20080319083228.GM11966@one.firstfloor.org>
	 <20080319020440.80379d50.akpm@linux-foundation.org>
	 <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com>
	 <20080320090005.GA25734@one.firstfloor.org>
	 <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com>
	 <20080321172644.GG2346@one.firstfloor.org>
	 <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com>
	 <20080322071755.GP2346@one.firstfloor.org>
	 <1206170695.2438.39.camel@entropy>
	 <20080322091001.GA7264@one.firstfloor.org>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 03:16:31 -0700
Message-Id: <1206180991.2438.43.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-22 at 10:10 +0100, Andi Kleen wrote:
> > Why not stick the bitmap in an xattr?
> 
> xattrs are too small for potentially large binaries

*sigh* this is probably true

> and a mess to manage (a lot of tools don't know about them)

At this point in time, all tools that don't support xattrs are
defective, but this is still probably true.

I just have an instinctive aversion towards the kernel mucking around in
ELF objects -- for one thing, you're going to have to blacklist
cryptographically signed binaries.


-- 
Nicholas Miell <nmiell@comcast.net>

