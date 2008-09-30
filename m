Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbYI3RWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbYI3RWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYI3RWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:22:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48710 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbYI3RWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:22:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JaqZMpnQoEuMoNQcpK69OkVsacsZ1dlnDb6v11CdGE6Tsg2b2KnnUvGYJ7KqyCgl+
	Fn2ek/jjRPvOlC6Gybysw==
Message-ID: <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com>
Date: Tue, 30 Sep 2008 10:22:06 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       prasad@linux.vnet.ibm.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, hch@lst.de,
       "David Wilder" <dwilder@us.ibm.com>,
       "Tom Zanussi" <zanussi@comcast.net>
In-Reply-To: <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080927134012.GA11930@Krystal>
	 <1222535419.16700.300.camel@lappy.programming.kicks-ass.net>
	 <20080929155004.GA11029@Krystal>
	 <1222709445.23876.70.camel@twins.programming.kicks-ass.net>
	 <20080929203124.GA23070@Krystal>
	 <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A 4 byte dataless payload is useless anyway.

Not at all convinced that's true - we used it for lots of things.
Start and end of irq event is one frequent example.

Also, in a compact mode, we can record start and end of
syscalls like this (without parameters).
