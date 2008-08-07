Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbYHGNVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbYHGNVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYHGNVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:21:22 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:46417 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYHGNVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:21:21 -0400
In-Reply-To: <g7d8a1$81o$2@taverner.cs.berkeley.edu>
To: daw-news@cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for	on
 access	scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Thu, 7 Aug 2008 12:19:01 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 07/08/2008 12:19:50,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 07/08/2008 12:19:50,
	Serialize complete at 07/08/2008 12:19:50,
	S/MIME Sign failed at 07/08/2008 12:19:50: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 07/08/2008 12:19:03,
	Serialize complete at 07/08/2008 12:19:03
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080807111955.C2A892FE8AA@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner wrote on 06/08/2008 23:24:01:

First of all you dropped all CC so I only found this by chance.

> Tvrtko wrote:
> >J. Bruce Fields wrote on 05/08/2008 23:55:24:
> >> On Mon, Aug 04, 2008 at 05:00:16PM -0400, Eric Paris wrote:
> >> > There is a consensus in the security industry that protecting 
against
> >> > malicious files (viruses, root kits, spyware, ad-ware, ...) by the 
way
> >> > of so-called on-access scanning is usable and reasonable approach.
> >> 
> >> Can you point to any helpful explanations of that concensus?
> >
> >I can't, but everyone is doing it so that is at least an implied 
> >consensus.
> 
> I don't think there is any such consensus, so I'm not expecting a
> technical explanation.  As best as I can tell, the primary explanation
> for why so many A/V vendors are doing it seems to be that it's a damn
> effective business model, and that may have as much of an effect on its
> widespread use as any technical merits or demerits.
> 
> Think about it: you get users to buy your A/V, then you tell them
> they need to pay a monthly subscription fee to get the latest virus
> signatures updates.  It's like crack.  Once you convince IT managers 
that
> "every machine needs to run A/V software", it's basically a guaranteed
> revenue stream for the A/V industry.  It's lucrative stuff, so it's no
> surprise that the A/V industry is nursing this for as long as it can go.
> And on many Microsoft platforms, the level of pain has been high enough
> that IT managers are willing to accept anything that reduces the level 
of
> pain even partially, so it's no surprise that A/V is so widely used 
today.
> It doesn't necessarily mean that it's the right way to go for the 
future,
> or that it's the right model for Linux, though.

You are entitled to your opinion and I am not in a position to get 
involved into these kinds of discussions.
 
> >> Off-hand it's surprising.  (A defense that depends on cataloging 
every
> >> possible individual attack sounds difficult!)
> 
> Of course.  Simple signature-based file-scanning has got deep technical
> limitations.  It can detect copycats and script kiddies but you'd be
> foolish to rely upon it to detect any kind of sophisticated attack.

So why you deleted my quote where I say signature based detection is not 
all we do?
 
> Let's put some numbers on it, for real commercial A/V software.
> I was at the Usenix Security conference last week, where one group of
> researchers presented a paper that included a chart showing how quickly
> McAfee A/V was able to detect new malware samples.  The researchers
> collected a large set of malware samples, and ran McAfee on it once
> a day or so to see how long it took for McAfee's signature database
> to be updated so it could detect those malware samples.  As I recall,
> the basic stats looked like this: about 30% of zero-day malware samples
> were detected on the first day they were released (and 70% weren't).
> The median number of days until a new malware sample was detected was
> about 40 days.  If you wanted hundreds of days, asymptotically McAfee 
was
> able to detect about 70% of the samples (and 30% were never detected).
> I expect the situation to get worse in the future, not better.

Do you have a link to that paper? It is all about the testing methodology 
and it would be interesting to read how the actually test in more detail. 

To bad they haven't used more than one product. They chose McAfee who, 
with all respect - and I am not representig my company but saying this 
privately, are not known for their swiftest response times. See here: 
http://blogs.pcmag.com/securitywatch/Results-2008q1.htm , they also seem 
to be good but not great in proactive detection.
 
> And keep in mind it's easy for an attacker to write a polymorphic or
> "metamorphic" virus that is basically undetectable with straightforward
> signature-based file scanning, so in an arms race the attackers have
> most of the advantages.

Again this goes back to my quote you deleted. Why is straightforward 
signature-based detection relevant? Who is doing only that today? For 
example please read this: 
http://www.infosectoday.com/Articles/Behavioral_Genotype.htm from where I 
quote:

"""
A good example of this is the Storm worm outbreaks that started in October 
2006 and continued into February 2007. See figure below. There were many 
variants, including Dorf and Dref worms, but one single behavioral 
genotype identity detected nearly 5000 different unique variants. Using 
traditional signature-based techniques, it would have required reactive 
detection, which would have taken a lot of man power and been much less 
effective at stopping the first waves of the threat. 
"""

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

