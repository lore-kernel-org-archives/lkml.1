Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYEEVBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYEEVBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYEEVAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:00:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:14353 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbYEEVAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=R5rm+sPx0s0BZvdA6OP3khs80hTg/SMtTTqfI743SgmNA+U5lNPMDuLB4JqMZJdJ1Grw6OqZZ7QC+4c/B0lJBTEmZ1K2O0uMtuD+AEaNZ9BL2JtI7hElVPvlcbzLnlYj2+h8pQ0SDFY7vU1ETzaI3PAiOT+zRRRCyp6e+X8vXJQ=
Message-ID: <30c6373b0805051400jebd4132ob23ec38bdf1ccb93@mail.gmail.com>
Date: Mon, 5 May 2008 14:00:51 -0700
From: "Kevin Burton" <burton@tailrank.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: Ability to limit or disable page caching?
Cc: "FD Cami" <francois.cami@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <20080505164446.2ec9a543@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	 <20080505131607.5556b1f2@olorin>
	 <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	 <20080505212831.22371732@olorin>
	 <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
	 <20080505164446.2ec9a543@cuia.bos.redhat.com>
X-Google-Sender-Auth: f5c6ddfd77f25158
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One of the problems is that the process pages (anonymous memory) and
> page cache pages live on the same LRU, so the kernel cannot always
> easily find the page cache pages when it is trying to evict something.

Ah... that makes sense.

> Once that is fixed, and replacement is biased towards evicting page
> cache pages, the system may do the right thing by itself.

Yeah.  That seems like it...

> I have no such tunable in my code (yet), because I would like the
> kernel to do the right thing automatically.  I will post a 2.6.25 based
> kernel RPM for Fedora 9 soon with the split LRU patch series applied.

With the same patch you linked to above?  No new code..

We're on Debian so I need to dive in and see how easy it would be for
us to compile our own kernel.

I've done it in the past but I've avoided running anything non-stock
for about 2 years now...

We're on 2.6.24 though but that's not a big issue.

> If you feel like testing/breaking it, I would be interested to see if
> it does indeed do the right thing for your workload or if it needs more
> tuning.

Well we'd be deploying it in product :).. what's the ETA into making
it into the official kernel?

Kevin


-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092
