Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbYL0HKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbYL0HKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 02:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYL0HKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 02:10:35 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56219 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYL0HKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 02:10:34 -0500
Date: Sat, 27 Dec 2008 08:12:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Message-ID: <20081227071208.GB27736@uranus.ravnborg.org>
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230360604-6711-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 01:50:04AM -0500, Mike Frysinger wrote:
> Use __asm__/__inline__ rather than asm/inline for all the functions
> exported to userspace.

I will imagine that we will see cleanup patches converting
these back to inline/asm.
How about doing this conversion as part of the headers_install.pl
script so we know it is always correct?

Then we can keep the familiar inline/asm in the kernel headers
and always use the correct __asm__, __inline__ version for our
exported headers.

	Sam
