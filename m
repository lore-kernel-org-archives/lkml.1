Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbYHKVza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbYHKVza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYHKVzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:55:16 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:63184 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbYHKVzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:55:15 -0400
Message-ID: <20080811175415.x7st9tf2ssg8og40@cubmail.cc.columbia.edu>
Date: Mon, 11 Aug 2008 17:54:15 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, containers@lists.linux-foundation.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: checkpoint/restart ABI
References: <20080807224033.FFB3A2C1@kernel>
	<200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>
	<200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz>
In-Reply-To: <1218484114.5598.43.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
X-CubMail-Sender: ol2104@columbia.edu
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Dave Hansen <dave@linux.vnet.ibm.com>:

> Arnd, Jeremy and Oren,
>
> Thanks for all of the very interesting comments about the ABI.

I second that !

>
> Considering that we're still *really* early in getting this concept
> merged up into mainline, what do you all think we should do now?
>
> My main goal here is just to get everyone to understand the approach
> that we're proposing rather than to really fix the interfaces in stone.
> I bet we're going to be changing them a lot before these patches
> actually get in.

I closely follow the valuable feedback and fix the code accordingly.

I propose to extend the proof of concept, to also be able to save and
restore "simple" open files (regular files, directories). My motivation
is twofold:

(1) Providing eough functionality for people to meaningfully play
with the proposed patches and try them.

(2) Demonstrate how I propose to handle shared resources (open files).

The first point is very important because it makes the concept actually
useful to a much broader set of programs than otherwise. I hope this
will attract a larger audience :)

To this end, I have already extended the patchset, and I should be
able to send something working in a day or two.

Oren.

