Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbYIWOCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbYIWOCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbYIWOAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:00:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33725 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbYIWOAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:00:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=V0dR9QbzXuWS2FGzSdeGA6azASexrsnJiNEcR2i1/1hhHxGpHrqdlsV6kD9DmdO73
	a4fx1En/oXqFONqNW5c2Q==
Message-ID: <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
Date: Tue, 23 Sep 2008 07:00:38 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Tom Zanussi" <zanussi@comcast.net>
Subject: Re: Unified tracing buffer
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, hch@lst.de,
       "David Wilder" <dwilder@us.ibm.com>
In-Reply-To: <1222147545.6875.135.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147545.6875.135.camel@charm-linux>
X-GMailtapped-By: 172.24.198.85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - get rid of anything having to do with padding, nobody needs it and its
> only affect has been to horribly distort and complicate a lot of the
> code
> - get rid of sub-buffers, they just cause confusion
> - get rid of mmap, nobody uses it
> - no sub-buffers and no mmap support means we can get rid of most of the
> callbacks, and a lot of API confusion along with them
> - add relay flags - they probably should have been used from the
> beginning and options made explicit instead of being shoehorned into the
> callback functions.

Actually, I think if you did all that, it'd be pretty close to what we
want anyway ...
