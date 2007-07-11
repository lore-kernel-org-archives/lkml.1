Return-Path: <linux-kernel-owner+w=401wt.eu-S1765532AbXGKTRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765532AbXGKTRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbXGKTRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:17:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757621AbXGKTRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:17:23 -0400
Date: Wed, 11 Jul 2007 12:16:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@frob.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: <20070711190434.D0F0C4D0555@magilla.localdomain>
Message-ID: <alpine.LFD.0.999.0707111215170.20061@woody.linux-foundation.org>
References: <20070711190434.D0F0C4D0555@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Roland McGrath wrote:
> 
> This patch adds the /sys/kernel/notes magic file.  Reading this delivers
> the contents of the kernel's .notes section.  This lets userland easily
> glean any detailed information about the running kernel's build that was
> stored there at compile time.

Umm. You seem to make it readable by everybody. That's a mistake, I think. 
I don't know if there is anything security-conscious there, but just on 
general principles, I don't think we really would want normal users 
reading kernel configuration info, no?

		Linus
