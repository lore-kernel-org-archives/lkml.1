Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZDGG1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZDGG1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbZDGG1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:27:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:54800 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453AbZDGG1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UXqqIlpUJHFzrrn3BGUBF2aJfn4iloTPnfSFu+EVPP1H8u067ojRy14SSF9pNbKC7t
         9bflabWfl30OVIhl23bKw/XbmalwbSj2ZPt1hhuan1r9aRpaXozpR6kB5Y81yKpK1EO8
         U3ewb5NsyN7Jw0PT7KnQEmcOxar/j1TP9HCa4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904062156180.4010@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
	 <20090406183157.GD7376@mit.edu>
	 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
	 <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>
	 <1239076379.17426.23.camel@think.oraclecorp.com>
	 <9b1675090904062113r2bd2b209hea1061cc54a0b9c0@mail.gmail.com>
	 <alpine.LFD.2.00.0904062120560.4010@localhost.localdomain>
	 <9b1675090904062148k7081be9bs26b5852d71a0a45c@mail.gmail.com>
	 <alpine.LFD.2.00.0904062156180.4010@localhost.localdomain>
Date: Tue, 7 Apr 2009 00:27:02 -0600
Message-ID: <9b1675090904062327k353f5ab3xe3b755e9fc78b059@mail.gmail.com>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Hua Zhong <hzhong@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 11:02 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So dynamic tuning is good. But at the same time, having a tuning option is
> _never_ an excuse for not getting the default right in the first place.
> It's just a cop-out to say "hey, the default may be wrong for you, but you
> can always tune it locally with XYZ".

Oh, right, you had mentioned that a few days ago about not liking to
have to tune stuff.  I agree, the kernel should just work, except in
rare cases.  But, with procfs, you could still have the default to
data=writeback, and realtime tuneable.  That is what I meant.

Anyhow, I don't want to take up too much of your time.  I wouldn't
want to know how busy you are. :P  No need to reply. :D
