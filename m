Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbYLAWC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbYLAWC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYLAWCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:02:14 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:48030 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYLAWCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wYMZHdO49XvMvy0EJr2UnlJ1rq74mys79Tj2OOG0BG6yELeM5+pZDxD0XlaZgVVHJA
         DUEfKwRd7Nst4cLjMqhno+9X/RW8PDBYIMFeU3Id71Ob0IRsz0eXgrY2f6RFgUnBC3PN
         ch9DPaa1YtkQqxi0xxRZvQvgZdPYbqNfy9TwI=
Message-ID: <84144f020812011402v3cb3ab24pf5cb6310f2d00c5b@mail.gmail.com>
Date: Tue, 2 Dec 2008 00:02:09 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, randy.dunlap@oracle.com,
       greg@kroah.com, adobriyan@gmail.com, remi.colinet@gmail.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0812011210030.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227980689.6354.24.camel@localhost.localdomain>
	 <20081129214207.GA6747@x200.localdomain>
	 <20081129234907.GA2340@kroah.com>
	 <20081201101245.0a2f3123.randy.dunlap@oracle.com>
	 <1228158811.3196.88.camel@calx>
	 <20081201120210.1ed16bd5.akpm@linux-foundation.org>
	 <84144f020812011207q29fe4b3fq11a9e55f171cf743@mail.gmail.com>
	 <alpine.LFD.2.00.0812011210030.3256@nehalem.linux-foundation.org>
X-Google-Sender-Auth: 0bd30a48077fd988
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, 1 Dec 2008, Pekka Enberg wrote:
>> Hmm, I thought Documentation/ABI/ was supposed to tell us what's an
>> ABI you can depend on and what's not. I mean, you shouldn't be
>> depending on anything but the interfaces documented in
>> Documentation/ABI/stable/, no?

On Mon, Dec 1, 2008 at 10:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Who is the f*cking MORON that thinks that "documentation" has any meaning
> what-so-ever?

Me, I suppose. At least that's the impression I got when being asked
to document any new kmemtrace debugfs files, for example.

On Mon, Dec 1, 2008 at 10:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> The fact that something is documented (whether correctly or not) has
> absolutely _zero_ impact on anything at all. What makes something an ABI
> is that it's useful and available. The only way something isn't an ABI is
> by _explicitly_ making sure that it's not available even by mistake in a
> stable form for binary use.

OK, but why do we have those different ABI "stages" in
Documentation/ABI then? The README file there seems to contradict what
you say. Or maybe I'm reading it wrong...

                         Pekka
