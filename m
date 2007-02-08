Return-Path: <linux-kernel-owner+w=401wt.eu-S1423335AbXBHUp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423335AbXBHUp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423333AbXBHUp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:45:58 -0500
Received: from raven.upol.cz ([158.194.120.4]:60875 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423335AbXBHUp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:45:58 -0500
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] fix cc-option-yn whitespace
In-Reply-To: <20070208200636.3222518005D@magilla.sf.frob.com>
References: <Pine.LNX.4.64.0702072024330.8424@woody.linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Thu, 8 Feb 2007 21:54:46 +0100
Message-Id: <E1HFGI2-0007Lt-Hk@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Roland McGrath <roland@redhat.com>
> Newsgroups: gmane.linux.kernel
> Subject: Re: [PATCH] fix cc-option-yn whitespace
> Date: Thu,  8 Feb 2007 12:06:35 -0800 (PST)

[]
> I have long ago sworn off thinking too hard about other people's makefiles
> that get arcane with GNU make features.  (You don't feel compelled to watch
> every piece of porn on the net that people use Linux to get there, do you?)

> So I just did the minimal tweak to fix the concrete regression, though I'd
> have to say that the "cleanup" has made things messier and more obfuscated.

Well, "refactoring". I think, it's hard to disagree, how messy $(CC) was
called there.

Thus, i tried to turn `m4' to `sh', because it's `sh' who does job. With
help of the mentors, it's done now. Good kick-start after stability
kernel release, nobody should relax (:.

Thanks.
____
