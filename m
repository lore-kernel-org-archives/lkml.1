Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYIZU42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYIZU42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIZU4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:56:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:49868 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYIZU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LOGwqJxwE/fhiWUEe98xLDFJqQa19GKdCQIsk55S35XGAdEWBRsxsyTpPBZHxUjVrb
         /po8KQ1XeP5NDbkV45r9ZLsf1/zzZkhmjM3pDa8xSBW8DjtVQktX+s4OzXbnVXIDMuRr
         E0RnGg15do6cwP1LeH22y9A0CQ/ZMliivYJ/I=
Message-ID: <f7848160809261356p1268f251pfc5bc8477862723@mail.gmail.com>
Date: Fri, 26 Sep 2008 16:56:19 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
In-Reply-To: <20080926201917.GA2591@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080925020608.GA13869@suse.de> <20080925042108.GA3931@suse.de>
	 <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
	 <20080925205328.GB11225@suse.de>
	 <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>
	 <20080925220454.GA12116@suse.de>
	 <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com>
	 <48DD2BA3.7050808@s5r6.in-berlin.de>
	 <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com>
	 <20080926201917.GA2591@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 4:19 PM, Greg KH <gregkh@suse.de> wrote:

> If you really don't like it, just never enable any of these modules,
> you'll never be bothered by it.

So you are saying if a distro ships allmodconfig kernels or ships the
crap modules in the hope that people will find them useful and I have
one of the devices in my machine that I don't care about - I should
just let the crap module autoload and crash/taint my kernel or take
the special step of blacklisting all of them or build my own kernel -
as unreasonable as ever.

Or  are you saying distros should not build the crap modules - that
doesn't make sense since it will drastically reduce the usage and
delay the identification of problems until later.

If they weren't loaded automatically - it will simplify things a lot -
people with those devices willing to use those modules can forcibly
load the ones they require - that gives you your beloved TAINT and
avoids any core kernel changes.

No offense but I don't think is helping Greg. So I will stop.

Parag
