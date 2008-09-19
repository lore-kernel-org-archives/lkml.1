Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbYISWTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbYISWTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYISWTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:19:34 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29152 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYISWTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:19:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:in-reply-to:mime-version:
	content-type:content-transfer-encoding:content-disposition:references:x-gmailtapped-by;
	b=J0MbfivPUM860a2OnLZH0MhHtGmQzlLhrGWkKHSbTBi4DDxoPCr5sjMUfIENYUj1s
	6G8WnYN30sUrwQStaNcww==
Message-ID: <33307c790809191519k7c1bcce7y3fa37efc23b0f9c@mail.gmail.com>
Date: Fri, 19 Sep 2008 15:19:28 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Martin Bligh" <mbligh@google.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "od Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <20080919224109.GB4491@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <20080919144258.ac787fdf.randy.dunlap@oracle.com>
	 <33307c790809191457y3ebffa28xa6d9ab6431554618@mail.gmail.com>
	 <20080919224109.GB4491@suse.de>
X-GMailtapped-By: 172.25.146.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sorry, probably lots of implicit assumptions in there that I forgot to explain
>
> Ids for event types. Either allocated dynamically, if the tracer needs
> new ids on each use, or statically assigned for others (like my fctrace
> or Steven's ftrace, I believe). Should we have a reserved range / registry
> for static allocation, maybe something like a very simple version of
> devices.txt?

Sure, but it's per-tracer, so hopefully won't be a big problem (eg fctrace
would have a different event-id namespace from blktrace)
