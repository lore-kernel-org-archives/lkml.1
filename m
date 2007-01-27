Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbXA0Udz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbXA0Udz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXA0Udz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:33:55 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:26600 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXA0Udy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:33:54 -0500
Message-ID: <8f3aa8d60701271233o62c2c5d1w7511ce26d944d93c@mail.gmail.com>
Date: Sat, 27 Jan 2007 12:33:54 -0800
From: "Martin Bligh" <mbligh@mbligh.org>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: [Ltt-dev] [PATCH 00/09] atomic.h : standardizing atomic primitives
Cc: "Willy Tarreau" <w@1wt.eu>, "Jan Dittmer" <jdittmer@ppp0.net>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       Ingo@maccavity.nachtwache.org, Christoph@maccavity.nachtwache.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Hellwig <hch@infradead.org>, "Linus Torvalds" <torvalds@osdl.org>,
       Molnar <mingo@redhat.com>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, "Paul Mackerras" <paulus@samba.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Douglas Niehaus" <niehaus@eecs.ku.edu>
In-Reply-To: <20070127123004.ea422fe4.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>
	 <20070127021834.e26e955d.akpm@osdl.org>
	 <20070127181116.GA5158@Krystal>
	 <20070127120512.04a98fcd.akpm@osdl.org>
	 <20070127200910.GC24090@1wt.eu>
	 <20070127123004.ea422fe4.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Wasn't it buildroot from Erik Andersen ?
> >
> >    http://buildroot.uclibc.org/
> >
>
> No, it was http://l4x.org/k/ It still appears to be operating, with
> scary-looking results.
>
> Jan, is there any way in which you can help us publish a full suite of
> cross-compiler binaries?

That's going to be tricky, even if they're statically linked, what architecture
do you want them for, etc? Plus some things seem to just refuse to statically
link now (anything with resolver code, though maybe gcc doesn't care).

If we can get the crosstool configs to build all that stuff ourselves,
for any platform, would be more flexible, IMHO.

M.
