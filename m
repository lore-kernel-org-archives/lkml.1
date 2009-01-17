Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbZAQI1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbZAQI1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 03:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZAQI1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 03:27:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbZAQI1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 03:27:07 -0500
Date: Sat, 17 Jan 2009 09:26:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Michael LeMay <mdlemay@epoch.ncsc.mil>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [slab corruption] BUG key_jar: Poison overwritten
Message-ID: <20090117082623.GB24905@elte.hu>
References: <20090115181612.GA27762@elte.hu> <16916.1232172471@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16916.1232172471@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1744]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > -tip testing found the rather scary looking slab corruption:
> 
> Unfortunately, I'm not in a position to look into this much right 
> now:-(. I'll see if I can find a test machine next week, but if not, 
> it'll be Feb before I can do anything about it.
> 
> That said, what sort of testing were you doing?

It was the regular -tip test cycle/iteration: booting the kernel and 
building the next new (random) kernel on that system, then booting that 
(random) kernel ... etc. The warning occured some time after bootup, so it 
probably triggered during the building of the next kernel. (one kernel 
build takes about 1-2 minutes to finish)

The problem was not reproducible - i tried the same config once more and 
it didnt produce the bug. (this system has no known hardware flukes)

	Ingo
