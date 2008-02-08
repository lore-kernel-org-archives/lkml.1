Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYBHUv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYBHUv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYBHUvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:51:17 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:55696 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYBHUvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:51:15 -0500
From: Junio C Hamano <junio@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Documentation/patch-tags, one more time
References: <9525.1202489479@vena.lwn.net>
	<alpine.LFD.1.00.0802080959130.2896@woody.linux-foundation.org>
cc: corbet@lwn.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Fri, 08 Feb 2008 12:50:40 -0800
In-Reply-To: <alpine.LFD.1.00.0802080959130.2896@woody.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 8 Feb 2008 10:00:36 -0800 (PST)")
Message-ID: <7v1w7njhpb.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, 8 Feb 2008, Jonathan Corbet wrote:
>> +
>> +These tags are:
>> +
>> +From: 	   	The original author of the patch.  This tag will ensure
>> +		that credit is properly given when somebody other than the
>> +		original author submits the patch.
>
> "From:" is not a tag. It's a special marker at the *top* (and _only_ the 
> top) of the email, which indicates authorship. It goes along with markers 
> like "Date:" and "Subject:", and has nothing to do with the sign-off-like 
> tags at the end.

True.  When one or more of these appear at the top (and _only_
the top) of a patch e-mail,

	From:		the person who wrote the patch
        Date:		the date of the authorship
        Subject:	the title of the patch

we override the corresponding values we obtain from the mail
header.  Documenting them is probably a good idea but they
should be described separately from S-o-b: and friends to avoid
confusion.


