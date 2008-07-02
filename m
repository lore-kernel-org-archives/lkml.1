Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbYGBMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbYGBMYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 08:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbYGBMYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 08:24:07 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:58856 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYGBMYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 08:24:06 -0400
Date: Wed, 2 Jul 2008 13:23:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Avi Kivity <avi@qumranet.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [-mmotm] some different buliding failures
In-Reply-To: <486B6B0E.7090503@qumranet.com>
Message-ID: <Pine.LNX.4.64.0807021312220.23201@blonde.site>
References: <486B1EE0.9060303@cn.fujitsu.com> <20080702040127.779a25c5.akpm@linux-foundation.org>
 <486B6B0E.7090503@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, Avi Kivity wrote:
> 
> I'm sure you have before, but can you remind me how to figure out what commit
> to apply mmotm onto?  I looked in series and origin.patch, but no luck.
> Applying on top of the last (first) commit in origin.patch's head did not
> work.

I look at its mm.patch, which today shows

 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 26
-EXTRAVERSION = -rc8
+EXTRAVERSION = -rc8-mm1

which hints that it applies to a 2.6.26-rc8 tree.

> Also, can I suggest including series in b-o.tar.gz?
> Nice to have everything in one tarball.

It is included, but (I can't tell you why) one level up.
You should find these three in the directory you extracted
into, I promptly move them down into broken-out itself.

.DATE
.DATE=2008-07-02-04-02
series

Hugh (probably _not_ extracted into your current directory ;)
