Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZKJVLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZKJVLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZKJVLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:11:40 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:42886 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZKJVLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:message-id:mime-version:content-type; q=
	dns; s=sasl; b=td0FFh5inNMxlvmp/QWtOvok2Y64xIrYahNi6TFH1W+3RfvQ9
	n5qHYvvIiP9pPLtz/802LaYFLKF0PCXvHUdaMFotUf6aWAV7Do92xcfZmL6RNnqW
	3wbsJIMfE9KQY/PHy1fBfSk6lo3IcT2sI09XA3Vp1/ut0z8URTdKrrYqZ8=
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
References: <20091110034831.GB26809@elte.hu> <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site>
 <4AF98C36.9040405@s5r6.in-berlin.de> <20091110193919.GC12686@suse.de>
 <20091110204537.GB18509@elte.hu>
From: Junio C Hamano <gitster@pobox.com>
Date: Tue, 10 Nov 2009 13:11:17 -0800
Message-ID: <7vhbt23x1m.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 9F5C6B48-CE3D-11DE-A97D-7B3EEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> Yeah. This new tagging scheme doesnt really allow anything 'new' per se 
> - it just helps the existing practice some more. All these commits were 
> -stable candidates anyway, in exactly the same order - the only 
> difference the new tagging scheme adds here is a more organized, 
> in-upsream-Git way of communicating it to you.

I am just a bystander, but if it were truly in-upstream-git way, wouldn't
you be forking a branch from the tagged target release (the latest of
2.6.32.X), and queuing only the changes meant for -stable to it, and
giving the name of the branch to git people and sending out patches from
that branch for e-mailed review and application?

There won't be any special tagging required, only a dedicated branch.

Or am I missing something?
