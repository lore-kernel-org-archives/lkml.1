Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXLDRDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXLDRDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXLDRD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:03:28 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:48450 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbXLDRD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:03:27 -0500
Message-ID: <47558855.1070705@cateee.net>
Date: Tue, 04 Dec 2007 18:03:17 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: 7eggert@gmx.de, Ray Lee <ray-lk@madrabbit.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: newlist: public malware discussion [Re: Out of tree module using
 LSM]
References: <9uzZr-6iz-19@gated-at.bofh.it> <9uUrm-5w3-27@gated-at.bofh.it>	 <9uVGz-7uQ-19@gated-at.bofh.it> <9uWCC-xI-13@gated-at.bofh.it>	 <9uWMp-Ix-13@gated-at.bofh.it> <9uX5A-1rs-1@gated-at.bofh.it>	 <9uXyK-24f-23@gated-at.bofh.it>  <E1IzK2o-00045u-Ha@be1.7eggert.dyndns.org> <1196729221.27258.72.camel@perihelion>
In-Reply-To: <1196729221.27258.72.camel@perihelion>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> On Mon, 2007-12-03 at 23:45 +0100, Bodo Eggert wrote:
>> Jon Masters <jonathan@jonmasters.org> wrote:
>>> On Thu, 2007-11-29 at 11:11 -0800, Ray Lee wrote:
>>>> On Nov 29, 2007 10:56 AM, Jon Masters <jonathan@jonmasters.org> wrote:
>>>> To lift Alan's example, a naive first implementation
>>>> would be to create a suffix tree of all of ESR's works, then scan each
>>>> page on fault to see if there are any partial matches in the tree.
>>> Ah, but I could write a sequence of pages that on their own looked
>>> garbage, but in reality, when executed would print out a copy of the
>>> Jargon File in all its glory. And if you still think you could look for
>>> patterns, how about executable code that self-modifies in random ways
>>> but when executed as a whole actually has the functionality of fetchmail
>>> embedded within it? How would you guard against that?
>> You can't scan all possible code for malware:
>> Take a random piece of code, possibly halting. Replace all halting conditions
>> using a piece of malware. Scan it. If it were possible to detect the malware
>> without false positives, you'd have solved the halting problem.
> 
> Good. I think you got the point of my sarcasm. My *point* was that we
> have two different camps of people here:
> 
> * Those who think some solution is better than none.

But we are talking about malicious programs, and so
there is a common motto:
"Poor Security Can Be Worse Than No Security", so
in this field often "none" is better that "some"

Really i don't understand why you push such module.
Malicious software in few generation (few years)
will use alternate methods. So the linux kernel
will be worse (and maybe will expose more bugs because
of complexity, and no problem are solved) but no
problem are solved.

See windoze: it is a patch after an other, so
the system is complex, unmaintainable and surely
not more secure. or do you want to change our behavior
as windows users: they compress files before to send
it, because of antiviruses policies.

If antiviruses will add security, we will not
have such big bot-nets and worms from the concurrent
OS.  Antiviruses offers only a short term cure.

ciao
	cate


> * Those who want an unobtainable, perfect solution.
> 
> I'm not criticising, each has their position. However, I was attempting
> to explain that I do fully "get it" by running through an example of how
> to work around more elementary on-access scanning schemes. I know that
> (no matter what marketing exists to the contrary), it is never possible
> to have perfect anti-malware software. But I do think there is a time
> and a place for Linux to help make some folks feel safer - on access
> file scanning isn't evil, and you don't have to use it! Freedom! :-)
> 
> Having spoken to a few people, I've created the following mailing list,
> so we can rant away and come up with a list of requirements to present
> for further discussion. Note that this is a case where I actually expect
> people to be *happy* with yet another email list :-) 
> 
> http://lists.printk.net/cgi-bin/mailman/listinfo/malware-list
> 
> Please sign up, and encourage interested third parties to do so too.
> Let's work this all out. Then I'll come back sometime over the holidays
> with a summary and some followup.
> 
>> If I had to design a virus scanner interface, I'd e.g. create a library*
>> providing an {open|mmap}_and_scan() function that would give me a clean
>> copy/really-private mapping of a scanned file, and a scan_{blob,file}()
>> function that would scan a block of memory/a file.
> 
> Although I'm open to the idea, I'm almost 100% convinced that nobody is
> going to buy modifying userspace applications one at a time. I think
> there is a legitimate feeling of this needing to be massaged by the
> kernel on some level. But I might be wrong - don't flame me.
> 
> Jon.
