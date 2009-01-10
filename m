Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZAJSjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZAJSjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZAJSjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:39:45 -0500
Received: from lazybastard.de ([212.112.238.170]:44034 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZAJSjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:39:44 -0500
Date: Sat, 10 Jan 2009 19:39:21 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add b+tree library
Message-ID: <20090110183921.GD20611@logfs.org>
References: <1231584446.3685.21.camel@johannes> <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com> <1231587428.3803.0.camel@johannes> <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 January 2009 21:29:04 +0900, KOSAKI Motohiro wrote:
> >
> > Joern is going to use it for logfs, that's the point. Not sure about
> > other filesystems.
> 
> Why can't you investigate other filesystem?
> if this library is used by only one fs, why does this library routine
> need to linux/lib/ directory?

Because it is not used for on-disk data structures.  It is an
alternative to radix trees, rbtrees, hash tables or linked lists.

Jörn

-- 
When in doubt, punt.  When somebody actually complains, go back and fix it...
The 90% solution is a good thing.
-- Rob Landley
