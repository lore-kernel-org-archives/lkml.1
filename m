Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbZC0U1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbZC0U1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbZC0U12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:27:28 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47640 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZC0U11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LYAs/uSoogsuXmB6VPz9QbeHKUvAYsWHW7pbUHXIGcOEUO8o7645SEG50ApYw4BUly
         XdzkVi46XAyrGhbNSRzwWgAu0xaGri0umQ0fLWKEuBb/hLE4NE6lLaThtOh6QvtXoE30
         KRxxu3rqxUURTI1r2EV/IqZU2khSLHS2XCNjc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903271138220.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu>
	 <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	 <20090327152221.GA25234@srcf.ucam.org>
	 <20090327161553.31436545@lxorguk.ukuu.org.uk>
	 <20090327162841.GA26860@srcf.ucam.org>
	 <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
	 <20090327170208.GA27646@srcf.ucam.org>
	 <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
	 <20090327183214.2e73b6a3@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0903271138220.3994@localhost.localdomain>
Date: Fri, 27 Mar 2009 22:27:23 +0200
Message-ID: <94a0d4530903271327w48a649e8h965a22c2a9b57b4d@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 8:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 27 Mar 2009, Alan Cox wrote:
>>
>> > So the fact is, "people should always use fsync" simply isn't a realistic
>> > expectation, nor is it historically accurate.
>>
>> Far too many people don't - and it is unfortunate but people should learn
>> to write quality software.
>
> You're ignoring reality.
>
> Your definition of "quality software" is PURE SH*T.
>
> Look at that laptop disk spinup issue. Look at the performance issue. Look
> at something as nebulous as "usability".
>
> If adding fsync's makes software unusable (and it does), then you
> shouldn't call that "quality software".
>
> Alan, just please face that reality, and think about it for a moment. If
> fsync() was instantaneous, this discussion wouldn't exist. But read the
> thread. We're talking 3-5s under NORMAL load, with peaks of minutes.

We are looking at the wrong problem, the problem is not "should
userspace apps do fsync", the problem is "how do we ensure reliable
data where it's needed".

It would be great if as a user I could have the option to set an fsync
level and say; look, I have a fast fs, and I really care about data
reliability in this server, so, level=0; or, hmm, what is this data
reliability thing? I just want my phone to don't be so damn slow,
level=5.

-- 
Felipe Contreras
