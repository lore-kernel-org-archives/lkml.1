Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbXFXTki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbXFXTki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXFXTkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:40:31 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:59011 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbXFXTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:40:30 -0400
In-Reply-To: <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-sparse@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Date: Sun, 24 Jun 2007 21:40:06 +0200
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Why?  I'd say it's not better than BUILD_BUG_ON_ZERO() use
>> instead of that ?:
>
> Oh, _that_ part I have no problem with. It's more that it seems that 
> the
> gcc optimization is ok at least as an extension.

Sure, but it's not an extension (yet), but an implementation
side-effect; it would have to be (semi-formally) defined in
the manual to be an extension.  Until that happens, anyone
using this "feature" risks haven his code broken at any time
(or, rather, his code already was broken but he didn't know
it).

See gcc.gnu.org/PR456 for more discussion.  Yes it's an old
bug...


Segher

