Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZKLRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZKLRzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZKLRzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:55:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40951 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753439AbZKLRzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:55:40 -0500
Date: Thu, 12 Nov 2009 17:56:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eran Liberty <liberty@extricom.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial_core: avoid Break bouncing
Message-ID: <20091112175649.145cbf18@lxorguk.ukuu.org.uk>
In-Reply-To: <20091112140504.6daf3824@pedra.chehab.org>
References: <20091112140504.6daf3824@pedra.chehab.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 14:05:04 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> From: Eran Liberty <liberty@extricom.com>
> 
> On some boxes, Break signal bounces, causing sysrq code to fail with some
> serial interfaces.
> 
> A solution were posted on LKML in 2008:
> http://lkml.indiana.edu/hypermail/linux/kernel/0809.2/0730.html
> 
> However, the fix weren't applied upstream.

Because it was NAKked at the time as it seemed to be a bug in Eran's
hardware platform not a generic problem and also because it breaks
autobauding on break as used by some (particularly older) software.

It's still NAKked and it would be helpful if people resubmitting old
stuff also looked through the thread attached the original submission.

You seem to have a single case of a user with some kind of buggy uart or
possibly other weirdness going on. That's probably worth investigating
more deeply but the patch NAKked before is not the solution due to its
side effects

(also btw it'll upset other people who script their sysrq stuff including
breaks and don't expect strange timing limits)

NAK again
