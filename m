Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYGID3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYGID3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 23:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYGID3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 23:29:47 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:35763 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbYGID3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 23:29:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAE7Hc0hMQWVt/2dsb2JhbACBXK8x
Date: Tue, 8 Jul 2008 23:29:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH 0/3] stop_machine enhancements and simplifications
Message-ID: <20080709032943.GA5565@Krystal>
References: <200807081750.55536.rusty@rustcorp.com.au> <20080708201012.GA21567@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080708201012.GA21567@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:27:51 up 34 days,  8:08,  3 users,  load average: 1.89, 1.35,
	1.34
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Tue, Jul 08, 2008 at 05:50:55PM +1000, Rusty Russell wrote:
> > Hi all,
> > 
> >    Here are the three stop_machine patches I've queued for the next merge
> > window.  The first two are pretty well tested via linux-next, the last is
> > recent but fairly straightforward.
> > 
> >    I'm assuming that Jason and/or Mathieu have need for the ALL_CPUS mod,
> > but it can be removed by the last of these patches (left in to reduce
> > transition breakage).
> 
> hi,
> 
> I added the 'ALL_CPUS' feature to support the architecture independent immediate 
> code that Mathieu wrote. So, if Mathieu needs it great, otherwise I have no 
> other code depending on it.
> 
> thanks,
> 
> -Jason 

Hi Rusty,

The immediate values implementation (the 'simple' version) uses this
patch. If we include your simplification, I'll have to modify the
immediate values patch a little bit so we deal with concurrent execution
of all the threads, as I pointed out in my earlier email.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
