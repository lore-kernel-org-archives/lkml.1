Return-Path: <linux-kernel-owner+w=401wt.eu-S965474AbXA3JrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965474AbXA3JrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965475AbXA3JrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:47:03 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43740 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965474AbXA3JrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:47:01 -0500
Date: Tue, 30 Jan 2007 12:46:09 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, libc-hacker@sources.redhat.com,
       libc-alpha@sources.redhat.com
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070130094609.GB2455@2ka.mipt.ru>
References: <20070129145227.GA10524@2ka.mipt.ru> <45BE238A.9060103@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <45BE238A.9060103@nortel.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 30 Jan 2007 12:46:15 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 10:40:42AM -0600, Chris Friesen (cfriesen@nortel.com) wrote:
> Evgeniy Polyakov wrote:
> >Hello.
> >
> >I'm pleased to announce initial userspace M-on-N threading model
> >implementation (for hackers) called NTL. 
> 
> If you haven't already, I suggest you look into the story of NGPT and 
> also read the NPTL white paper 
> (http://people.redhat.com/drepper/nptl-design.pdf) especially section 
> 5.1 describing why they went with a 1:1 model.

Of course I read this, but it does not change anything.

NGPT had 2 times slower start time than NPTL, and NTL has 2-20 times
faster than NPTL, so I think NGPT had too major problems to get it 
into comparison.

I described in details why and how M:N model better, and its drawbacks
include all issues mentioned by Ulrich Drepper, but nevertheless its
advantages are far too superiour than those which can be provided by 1:1
model.

> Chris

-- 
	Evgeniy Polyakov
