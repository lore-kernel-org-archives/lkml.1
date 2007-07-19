Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbXGSVzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbXGSVzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763336AbXGSVyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:54:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763019AbXGSVys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:54:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: which signal is sent to freeze process?
Date: Fri, 20 Jul 2007 00:02:50 +0200
User-Agent: KMail/1.9.5
Cc: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>, linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <A3258B497F1C1441AD36A2E8B45FD6285508CB@scsmsx412.amr.corp.intel.com> <200707191459.20998.nigel@nigel.suspend2.net>
In-Reply-To: <200707191459.20998.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200002.50958.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 19 July 2007 06:59, Nigel Cunningham wrote:
> Hi.
> 
> On Thursday 19 July 2007 14:09:56 Agarwal, Lomesh wrote:
> > Can you point me to code where kernel captures process in signal
> > handling and code which runs after suspend to ram is finished?
> 
> Sure.
> 
> It's in kernel/signal.c (get_signal_to_deliver) for x86 and x86_64, and 
> arch/<name>/kernel/signal.c for other arches. The support for other arches is 
> the place x86 & x86_64 used to use - I wonder if they should be going away 
> (Rafael cc'd to raise this point with him).

That's a good question. :-)  I'll have a look.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
