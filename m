Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYIWESS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYIWESS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 00:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYIWESF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 00:18:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34751 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYIWESD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 00:18:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=hYzVu+/zTruuDISoHTFjMe6MmqwHC3GLrgAY9el366HN+ibtnRjJi5oWLvuMG1p/Z
	DC9vBfQXlrlMaiIfWm/cQ==
Message-ID: <33307c790809222117w655894ffoce7950fb72b60e3f@mail.gmail.com>
Date: Mon, 22 Sep 2008 21:17:46 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: Unified tracing buffer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <48D86C38.9000407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
	 <48D81B5F.2030702@redhat.com>
	 <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
	 <48D832B6.3010409@redhat.com>
	 <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org>
	 <adaod2f649o.fsf@cisco.com>
	 <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809222335400.26011@gandalf.stny.rr.com>
	 <48D86C38.9000407@redhat.com>
X-GMailtapped-By: 172.25.146.19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> yes, if event c is an interrupt event :-).
>
>  cpu 0       cpu 1
>            hit event d
> hit event a
> log event a
>            irq event c
>            log event c
> hit event b
> log event b
>            log event d
>
> so, I think if we really need to order events, we have to stop
> irq right after hitting an event.

How could you fix that in any practical way?
