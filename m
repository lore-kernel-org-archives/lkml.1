Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZDLUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZDLUzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZDLUzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 16:55:12 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58810 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbZDLUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 16:55:09 -0400
Date: Sun, 12 Apr 2009 21:55:05 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>, Jeff Garzik <jeff@garzik.org>,
       Oleg Drokin <green@linuxhacker.ru>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Attempt at "stat light" implementation
Message-ID: <20090412205505.GJ4394@shareable.org>
References: <20090407062356.GA1336463@fiona.linuxhacker.ru> <20090407173248.GC31824@shareable.org> <49DB8F8E.9010605@garzik.org> <20090407175617.GF31824@shareable.org> <20090407182157.GW3204@webber.adilger.int> <a36005b50904071230h4850b5e3q2ad72a8e8babe09a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50904071230h4850b5e3q2ad72a8e8babe09a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> As for making the interface extendable.  In all the years there hasn't
> really been much need to extend the stat structure (ignoring extended
> attributes).  So, I'd not be worried about using a simple 32-bit
> bitmask to select the fields to include in the fast stat.

I agree about 32 bits being enough.

I think there has been some demand for new fields, but it's not been
strong enough to justify all the breakage from changing the normal
stat structure.

That's why we have generic filesystem ioctls: FS_IOC_GETFLAGS,
FS_IOC_GETVERSION, which return things which would naturally go with
stat if it were free to do so (but it isn't).

-- Jamie
