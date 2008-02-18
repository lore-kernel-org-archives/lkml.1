Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbYBRWub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbYBRWub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 17:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYBRWuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 17:50:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:58367 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYBRWuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 17:50:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oodxRe+YJu4cyiUqFTPFFczca9lADaICcnDOxXK/+YRaZ01HoJ8bkH4X3IcdmN6FIbdgBqODs/SI2tqAetpNui1lvBKPDVCyrZmzKtFPzVsWLbqMJREW/o1RM0Xz0R6BmTY3QV5C1XQhPKcFceYnAhCZSzutANoqZrS5igWFiD8=
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
In-Reply-To: <200802182343.12749.mb@bu3sch.de>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
	 <200802182324.45267.mb@bu3sch.de>
	 <20080218223410.GD23181@flint.arm.linux.org.uk>
	 <200802182343.12749.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 14:50:30 -0800
Message-Id: <1203375030.5757.75.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-18 at 23:43 +0100, Michael Buesch wrote:
> On Monday 18 February 2008 23:34:10 Russell King wrote:
> > 
> > Well, don't expect this driver to work until you fix your broken
> > assumptions about alignment requirements.
> 
> Mr King, I'm not an idiot!
> 
> Can you _please_ explain what makes ARM so special here?
> Why can't we have an array of this structure on ARM?
> 
> struct ssb_device_id {
>        __u16   vendor;
>        __u16   coreid;
>        __u8    revision;
> };
> 
> I will not apply any patches that I don't understand.
> Why doesn't the compiler handle this? What's special? Can you please explain?
> 

I believe this is a good place to start (although I could be totally
off-base)

http://lkml.org/lkml/2007/11/22/120

Harvey

