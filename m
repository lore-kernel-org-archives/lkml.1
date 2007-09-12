Return-Path: <linux-kernel-owner+w=401wt.eu-S968471AbXILNxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968471AbXILNxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXILNxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:53:44 -0400
Received: from khc.piap.pl ([195.187.100.11]:54127 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbXILNxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:53:43 -0400
To: Stef Epardaud <stef@epardaud.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Filesystem silent crash with EXT3
References: <20070912120203.GA23510@inforealm.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 12 Sep 2007 15:53:40 +0200
In-Reply-To: <20070912120203.GA23510@inforealm.org> (Stef Epardaud's message of "Wed, 12 Sep 2007 14:02:03 +0200")
Message-ID: <m3hcm0dm6z.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stef Epardaud <stef@epardaud.net> writes:

> I had no idea my EXT3 filesystem could go wrong without notifying me
> (fsck thought the filesystem was clean before I forced it). Is this
> normal ?

Filesystem clean = the "dirty" flag is not set. With journaling
fs it basically means the kernel didn't found errors during
operation.
It doesn't mean there are no errors.

> If not, what can I do to figure out what went wrong ?

I'd check with memtest86. Silent fs corruption is usually caused
by faulty hardware such as RAM.

> I am in the process of getting a live linux CD to look at the disk,
> maybe there are some logs that can help.

I wouldn't count on it.

> Note that it's the first time I've lost a EXT3 (or EXT2) filesystem
> without having experienced any system crash or power failure to explain
> the filesystem problem.

A system crash or especially power failure shouldn't damage ext3fs.
-- 
Krzysztof Halasa
