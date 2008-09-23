Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYIWDrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYIWDrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYIWDr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:47:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32040 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753202AbYIWDr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:47:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=pzPsuz84ZpakdcQewLh9ZOzC3WBgNZuvuZOf4u1zbsvijpwYjL1btMF4hN7Gc2Ha4
	QnAlwiOyNNbWYD+SK4dcQ==
Message-ID: <33307c790809222047h7eaae674r8dd165ab8744910a@mail.gmail.com>
Date: Mon, 22 Sep 2008 20:47:12 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Unified tracing buffer
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <878wtjr0y1.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <878wtjr0y1.fsf@basil.nowhere.org>
X-GMailtapped-By: 172.25.146.36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> During kernel summit and Plumbers conference, Linus and others
>> expressed a desire for a unified
>> tracing buffer system for multiple tracing applications (eg ftrace,
>> lttng, systemtap, blktrace, etc) to use.
>
> This is what relayfs always was promised to be, but apparently
> never quite became. But before adding a new one I would recommend
> to remove relayfs first.

It's a little different, though similar. relayfs is an unstructured buffer.
This would be a sequence of events with a common timestamp format,
and hopefully other commonalties too.

I agree that the underlying buffer structure could be shared, as has
been pointed out (buried in this long thread). However, in another buried
comment, it was pointed out that relayfs would have no users once this
was done, so ...

I don't think we can remove relayfs before adding this and switching over
the users though (possibly it could all be done at the same time, but messy)
