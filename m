Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbXLDAsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbXLDAsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 19:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXLDAsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 19:48:11 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:48845 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXLDAsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 19:48:09 -0500
Subject: newlist: public malware discussion [Re: Out of tree module using
	LSM]
From: Jon Masters <jonathan@jonmasters.org>
To: 7eggert@gmx.de
Cc: Ray Lee <ray-lk@madrabbit.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
In-Reply-To: <E1IzK2o-00045u-Ha@be1.7eggert.dyndns.org>
References: <9uzZr-6iz-19@gated-at.bofh.it> <9uUrm-5w3-27@gated-at.bofh.it>
	 <9uVGz-7uQ-19@gated-at.bofh.it> <9uWCC-xI-13@gated-at.bofh.it>
	 <9uWMp-Ix-13@gated-at.bofh.it> <9uX5A-1rs-1@gated-at.bofh.it>
	 <9uXyK-24f-23@gated-at.bofh.it>  <E1IzK2o-00045u-Ha@be1.7eggert.dyndns.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 03 Dec 2007 19:47:00 -0500
Message-Id: <1196729221.27258.72.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-03 at 23:45 +0100, Bodo Eggert wrote:
> Jon Masters <jonathan@jonmasters.org> wrote:
> > On Thu, 2007-11-29 at 11:11 -0800, Ray Lee wrote:
> >> On Nov 29, 2007 10:56 AM, Jon Masters <jonathan@jonmasters.org> wrote:
> >> > On Thu, 2007-11-29 at 10:40 -0800, Ray Lee wrote:
> >> > > On Nov 29, 2007 9:36 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> >> > > > > closed. But more importantly further access to it can be blocked
> >> > > > > until appropriate actions are taken which also applies with your
> >> > > > > example, no? Is
> >> > > >
> >> > > > That bit is hard- very hard.
> 
> >> To lift Alan's example, a naive first implementation
> >> would be to create a suffix tree of all of ESR's works, then scan each
> >> page on fault to see if there are any partial matches in the tree.
> > 
> > Ah, but I could write a sequence of pages that on their own looked
> > garbage, but in reality, when executed would print out a copy of the
> > Jargon File in all its glory. And if you still think you could look for
> > patterns, how about executable code that self-modifies in random ways
> > but when executed as a whole actually has the functionality of fetchmail
> > embedded within it? How would you guard against that?
> 
> You can't scan all possible code for malware:
> Take a random piece of code, possibly halting. Replace all halting conditions
> using a piece of malware. Scan it. If it were possible to detect the malware
> without false positives, you'd have solved the halting problem.

Good. I think you got the point of my sarcasm. My *point* was that we
have two different camps of people here:

* Those who think some solution is better than none.
* Those who want an unobtainable, perfect solution.

I'm not criticising, each has their position. However, I was attempting
to explain that I do fully "get it" by running through an example of how
to work around more elementary on-access scanning schemes. I know that
(no matter what marketing exists to the contrary), it is never possible
to have perfect anti-malware software. But I do think there is a time
and a place for Linux to help make some folks feel safer - on access
file scanning isn't evil, and you don't have to use it! Freedom! :-)

Having spoken to a few people, I've created the following mailing list,
so we can rant away and come up with a list of requirements to present
for further discussion. Note that this is a case where I actually expect
people to be *happy* with yet another email list :-) 

http://lists.printk.net/cgi-bin/mailman/listinfo/malware-list

Please sign up, and encourage interested third parties to do so too.
Let's work this all out. Then I'll come back sometime over the holidays
with a summary and some followup.

> If I had to design a virus scanner interface, I'd e.g. create a library*
> providing an {open|mmap}_and_scan() function that would give me a clean
> copy/really-private mapping of a scanned file, and a scan_{blob,file}()
> function that would scan a block of memory/a file.

Although I'm open to the idea, I'm almost 100% convinced that nobody is
going to buy modifying userspace applications one at a time. I think
there is a legitimate feeling of this needing to be massaged by the
kernel on some level. But I might be wrong - don't flame me.

Jon.


