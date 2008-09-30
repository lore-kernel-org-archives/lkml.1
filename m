Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYI3To2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYI3To2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYI3ToS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:44:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11632 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYI3ToR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:44:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=RMFMo2mSzILM3zMKxvP6isAGTbRQX7NHscnUSobmlv4C4uVWTMxXXqVpKhUCRIVg6
	LWL+QcEUkLUGPG+seS4tw==
Message-ID: <33307c790809301244x40218be6of61b53104b8d7da3@mail.gmail.com>
Date: Tue, 30 Sep 2008 12:44:08 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       prasad@linux.vnet.ibm.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, hch@lst.de,
       "David Wilder" <dwilder@us.ibm.com>,
       "Tom Zanussi" <zanussi@comcast.net>
In-Reply-To: <20080930183531.GA20670@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080927134012.GA11930@Krystal> <20080929155004.GA11029@Krystal>
	 <1222709445.23876.70.camel@twins.programming.kicks-ass.net>
	 <20080929203124.GA23070@Krystal>
	 <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com>
	 <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com>
	 <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com>
	 <20080930181436.GA19690@Krystal>
	 <alpine.DEB.1.10.0809301421330.6224@gandalf.stny.rr.com>
	 <20080930183531.GA20670@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You are actually using them to put redundant information that could be
> encoded differently and thus save 4 bits per event records, more or less
> what will be needed by most tracers (15 IDs, 1 reserved for an extended
> ID field).

You have 15 event types that are useful with no data payload at all?

> So the fact that you use them does not mean they are really required,
> and I don't think such duplicated information actually makes things more
> solid. Maybe just more obscure ?

This is all over 1 bit of information, right? Since you need at least 1 for
the timestamp stuff.
