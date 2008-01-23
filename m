Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYAWOtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYAWOtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYAWOtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:49:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57156 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYAWOtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:49:23 -0500
Date: Wed, 23 Jan 2008 06:49:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: test case for the RODATA config option
Message-ID: <20080123064905.5d05509a@laptopd505.fenrus.org>
In-Reply-To: <p731w88nc0p.fsf@crumb.suse.de>
References: <20080122144420.4ebcf95f@laptopd505.fenrus.org>
	<p731w88nc0p.fsf@crumb.suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Jan 2008 10:09:58 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > This patch adds a test module for the DEBUG_RODATA config
> > option to make sure change_page_attr() did indeed make
> > "const" data read only.
> 
> The only that this does that is not done pretty much equivalently
> by pageattr-test.c (it just checks G instead of W) is testing the
> kernel text mapping on 64bit. On 32bit it is fully redundant I
> believe.

What it does is check if the rodata marking was succesful. That's more than just checking 
change_page_attr() itself, and basically a reasonably self self-check of mark_rodata_const().


> Testing the kernel mapping might be a good idea, but I would
> suggest adding it to pageattr-test.c

where we move the actual test function... I don't really care. Once pageattr-test.c
is merged I have absolutely no problem moving it there if it's the right place...
(one can argue that it should be in or near the mark_rodata_const() function instead
since it tests that one).
Just like the NX test I wrote yesterday (and will post later today) probably wants to live
somewhere close to the NX code.
 
> Yes I'm sure these basic facts will not stop it from being 
> applied anyways; just wanted to point it out for the benefit
> of the list readers.

Please spare me the bitter, undeserved sarcasm; I don't remember doing anything
to you to deserve that.
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
