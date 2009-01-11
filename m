Return-Path: <linux-kernel-owner+w=401wt.eu-S1751491AbZAKIbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbZAKIbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 03:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZAKIbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 03:31:13 -0500
Received: from lazybastard.de ([212.112.238.170]:56322 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZAKIbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 03:31:12 -0500
Date: Sun, 11 Jan 2009 09:30:34 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090111083034.GB30090@logfs.org>
References: <1231587428.3803.0.camel@johannes> <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com> <20090110183921.GD20611@logfs.org> <1231613042.3706.16.camel@johannes> <87fxjrgd9s.fsf@basil.nowhere.org> <20090110202315.GE20611@logfs.org> <20090110212740.GE31579@mit.edu> <20090110220135.GF20611@logfs.org> <20090110142330.295a8847.akpm@linux-foundation.org> <1231631840.13420.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231631840.13420.24.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 January 2009 00:57:20 +0100, Peter Zijlstra wrote:
> 
> B-tree's however have one thing over RB-trees, B-trees can be made
> RCU-safe whereas RB-trees cannot be -- the only problem is that Joern's
> doesn't do that.

And yours doesn't support multiple key sizes afaics.  I don't mind
using your version as a basis, so long as my^Wboth requirements get
fulfilled. ;)

Do you see a problem combining rcu with keys being an array of unsigned
long?

Jörn

-- 
Schrödinger's cat is <BLINK>not</BLINK> dead.
-- Illiad
