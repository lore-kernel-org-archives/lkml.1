Return-Path: <linux-kernel-owner+w=401wt.eu-S1759867AbYHFPfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbYHFPfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbYHFPda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:33:30 -0400
Received: from mail12.ca.com ([141.202.248.38]:45160 "EHLO mail12.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577AbYHFPdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:33:25 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Date: Wed, 6 Aug 2008 11:33:23 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4AF8@USILMS12.ca.com>
In-Reply-To: <20080806150857.GD14109@mit.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Thread-Index: Acj31l+9TvXr6lJGQnOIIc268dLFPgAAXEFA
References: <20080805205129.37d873f0@bree.surriel.com> <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com> <20080806150857.GD14109@mit.edu>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Theodore Tso" <tytso@MIT.EDU>
Cc: "Rik van Riel" <riel@redhat.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 06 Aug 2008 15:33:23.0272 (UTC) FILETIME=[C3116480:01C8F7D9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Theodore Tso [mailto:tytso@MIT.EDU] 
Sent: Wednesday, August 06, 2008 11:09 AM
To: Press, Jonathan
Cc: Rik van Riel; linux-kernel@vger.kernel.org;
malware-list@lists.printk.net; linux-security-module@vger.kernel.org;
Arjan van de Ven
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
alinuxinterfaceforon access scanning

On Wed, Aug 06, 2008 at 08:10:53AM -0400, Press, Jonathan wrote:
> I think if it as being like the Sieve of Eratosthenes.  The further
down
> you go, the more numbers drop out.  In AV scanning, each step of the
way
> removes some percentage of the harmful files, and closes the window of
> time that they have to operate or migrate.  Or maybe it's like
spraying
> insecticide when there is an outbreak of some deadly mosquito-borne
> illness.  Without getting into the political issues about spraying,
> because this is JUST AN EXAMPLE -- would you not spray because 5% of
the
> bugs would still be left behind?  Wouldn't you then spray again,
because
> you wipe out another 95%?

The problem with your example is that it ignores the cost; the cost in
code maintenance; the cost in performance, etc.  That's the problem an
absolutist view towards security.  Going back to the your sparying
analogy, if the illness is considered *so* utterly deadly that you don't
consider the costs of beneficial insects dieing, children getting
exposed so badly that they get cancer five years later, etc. --- then
the argument would be heck, let's spray every day! Let's spray every
hour!  Let's have a insectside misters going 24 hours a day in the parks
and in the schools!!!

In the TSA example, let's force every single traveller to strip naked
publically and be submitted to body cavity searches!  Since
**obviously** stopping terrorist bombs is so important that no other
considerations need to be taken into account.  Oh, and we should
obviously also give all of our financial information to the security
agencies so they can do futher screens to look for terrorists; who cares
about the risks that laptops with all of that unencrypted data will be
stolen out of a locked office in the San Francisco airport?

Similarly there are costs to doing all of this extra scanning.  You're
getting carried away here way you say that it never hurts to do extra
scanning, and that we don't need to decide whether or not it makes sense
to do it all.  That's just stupid.  The whole defense in depth, taken to
extremes, leads to completely nonsensical thinking.  Security is
*defintiely* a cost/benefit tradeoff, and to do something meaningful
here we need to think rationally about the threat environment --- and
part of that threat environment is the existing security systems in
Linux, which are definitely far more powerful than what DOS/Windows
have.

[JON PRESS] You're absolutely right, there is a cost-benefit tradeoff,
and I am not ignoring it at all.  Reasonable people can have a
reasonable discussion about what constitutes enough or too much
scanning.  From my experience with customers, many if not most
enterprises consider any outbreak with any serious damage to be too
much, and don't mind redundant scanning if it will help to prevent it.

Even so, I don't think your extreme examples are really parallel to what
we do.  Personally, I think that scanning on open, exec and close is not
excessive.  

And in fact, we do go out of our way to avoid scanning when it really
isn't necessary.  For example, that's the reason that we want a cache --
and again reasonable people can have a reasonable discussion about how
to handle that.

