Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYBUWxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYBUWxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbYBUWxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:53:43 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:63553 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYBUWxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:53:42 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 17:53:42 EST
From: Junio C Hamano <junio@pobox.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Implement getgeo for Xen virtual block device.
References: <47BDE731.60801@goop.org>
 <alpine.LFD.1.00.0802211315190.19896@woody.linux-foundation.org>
 <47BDEA5E.4070800@goop.org>
 <alpine.LFD.1.00.0802211337220.19896@woody.linux-foundation.org>
 <47BDF151.30809@goop.org>
Date: Thu, 21 Feb 2008 14:46:36 -0800
In-Reply-To: <47BDF151.30809@goop.org> (Jeremy Fitzhardinge's message of
 "Thu, 21 Feb 2008 13:46:57 -0800")
Message-ID: <7vodaarkqb.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Putting the From: in the Signed-off-by block is a result of two thoughts:
>
>   1. putting it at the top makes the most sense from an email
>      perspective, but it often seem to get lost by various
>      patch-posting programs if it gets tangled in the Subject/summary
>      part of the patch.  The result is that it needs to float in an odd
>      way:
>
>          Subject: wooble the foo
>
>          From: Foo Woobler <foo@wooble.com>
>
>          Wooble foos in the appropriate manner.
>
>          Signed-off-by: Foo Woobler <foo@wooble.com>
>          Cc: Bar Mangler <bar@mangle.org>
>
>   2. There's already a block of email addresses which describe how
>      people relate to this patch,...

In addition to "From: ", you can place "Subject: " and "Date: "
at the beginning to make sure Linus or whoever applies patches
would not get the authorship information from the e-mail itself
you send (this is especially true when you are forwarding
somebody else's patch).

Mnemonic is that the equivalents to E-mail headers go at the
top.  You will never have Signed-off-by:, Tested-by:, nor
Acked-by: in your e-mail headers.  They go at the bottom.

	This is just a toolsmith speaking, I am not in any way
	trying to set a policy for this list.

I do not know where that Cc: near S-o-b: comes from, though.  It
is not accepted at the top as there is no place for such an
information in commits.
