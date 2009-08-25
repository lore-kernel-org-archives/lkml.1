Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZHYTiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZHYTiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbZHYTiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:38:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59898 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZHYTiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:38:05 -0400
Subject: Re: [PATCH] x86: Execute WP test after interrupts are enabled
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <4A943CBD.60808@goop.org>
References: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi>
	 <4A943CBD.60808@goop.org>
Date: Tue, 25 Aug 2009 22:38:05 +0300
Message-Id: <1251229085.25686.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 12:16, Pekka Enberg wrote:
> > Commit 83b519e8b9572c319c8e0c615ee5dd7272856090 ("slab: setup allocators
> > earlier in the boot sequence") changed the boot sequence to call
> > mem_init() early. Unfortunately Xen is not prepared to handle the WP test at
> > that point so we need to make the test run later.
> >
> > This patch fixes the Xen boot failures reported by Arnd Hannemann.

On Tue, 2009-08-25 at 12:34 -0700, Jeremy Fitzhardinge wrote:
> I don't think this is the real fix, and it seems a bit ugly.  I'm OK
> with it as a workaround, but I think it will end up getting reverted if
> applied.

Yeah, I'm fine with that. It's just that we're really late in the
release cycle now so I'd like to keep the fix as simple as possible. Do
you think the real bug lies in Xen or...?

			Pekka

