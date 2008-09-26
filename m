Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYIZUMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYIZUMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYIZULv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:11:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:43207 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYIZULu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FUUQK0aNrZesR6j8xbJejmBylSFjyExtjc7exCXgh6uokOnAKBrFY18zNtlXpxM/Om
         RQT673uORTz1qG6S7JkzWXdOuaRY/pWnUN27uYVEjWykQgld+Qx8oAe4hlr1lHr8bcN5
         YjtjKMXjnMcP9m/n/EMl2NkXH4svzOHQNNDx4=
Message-ID: <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com>
Date: Fri, 26 Sep 2008 16:11:49 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Cc: "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
In-Reply-To: <48DD2BA3.7050808@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924230054.GA27730@suse.de> <20080925020608.GA13869@suse.de>
	 <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>
	 <20080925042108.GA3931@suse.de>
	 <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
	 <20080925205328.GB11225@suse.de>
	 <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>
	 <20080925220454.GA12116@suse.de>
	 <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com>
	 <48DD2BA3.7050808@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 2:36 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> It _is_ necessary.  I for one don't want to have to remember that driver
> foobar was in "staging" state in kernel 2.6.31-rc5, but not anymore in
> 2.6.32-rc1.

Just name the staging modules with _stg prefix like I said - easier to
spot _stg in the module list than decoding the taint. Whenever
(doubtful tone here) it graduates, remove the suffix. Driver modules
load automatically any way so the name change is not going to make a
difference.

It is nice to not have to change core kernel code and annoy users with
warnings for the staging crap even if it is just 24 lines or whatever
- if we can - and I don't see why we cannot. Staging, just like
crapping, has to be a totally isolated, zero side effect, zero
annoyance (to others) type thing :) So let's please get rid of that
taint and warning already :)

Parag
