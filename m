Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYFKTnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYFKTnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYFKTnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:43:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbYFKTnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:43:16 -0400
Date: Wed, 11 Jun 2008 12:43:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc5-mm2 - kernel BUG at
 arch/x86/kernel/setup.c:388!
Message-Id: <20080611124303.017b853e.akpm@linux-foundation.org>
In-Reply-To: <19f34abd0806111112w5a6ed080jc098612806398828@mail.gmail.com>
References: <19f34abd0806111112w5a6ed080jc098612806398828@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 20:12:04 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On 6/9/08, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > Hi Andrew,
> >
> > The 2.6.26-rc5-mm2 kernel panic's, while booting up on the x86_64
> > box with the attached .config file.
> 
> (Please apologize for the strange way of replying to this message. It
> seems that LKML gave up delivering to my address, so I'm currently
> reading off lkml.org.)
> 
> This should already be fixed, but Andrew refused to apply the patch
> before releasing the -mm1 (and -mm2 apparently).

a) nobody ever sent it to me and b) I was told about it too late to be
able to go work out what tree it was in, cherrypick it then merge it.

> I'm attaching the
> patch, can you see if it helps?

hallelujah, thanks.  I already fished it out of linux-next.

I'm still hanging onto the 2.6.26-rc5-mm1 origin.patch and
linux-next.patch because I'm desperately trying to get things vaguely
stabilised so some VM testing can happen.

