Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYHFPJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYHFPJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYHFPJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:09:13 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43597 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbYHFPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:09:12 -0400
Date: Wed, 6 Aug 2008 11:08:58 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080806150857.GD14109@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Press, Jonathan" <Jonathan.Press@ca.com>,
	Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>
References: <20080805205129.37d873f0@bree.surriel.com> <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 08:10:53AM -0400, Press, Jonathan wrote:
> I think if it as being like the Sieve of Eratosthenes.  The further down
> you go, the more numbers drop out.  In AV scanning, each step of the way
> removes some percentage of the harmful files, and closes the window of
> time that they have to operate or migrate.  Or maybe it's like spraying
> insecticide when there is an outbreak of some deadly mosquito-borne
> illness.  Without getting into the political issues about spraying,
> because this is JUST AN EXAMPLE -- would you not spray because 5% of the
> bugs would still be left behind?  Wouldn't you then spray again, because
> you wipe out another 95%?

The problem with your example is that it ignores the cost; the cost in
code maintenance; the cost in performance, etc.  That's the problem an
absolutist view towards security.  Going back to the your sparying
analogy, if the illness is considered *so* utterly deadly that you
don't consider the costs of beneficial insects dieing, children
getting exposed so badly that they get cancer five years later,
etc. --- then the argument would be heck, let's spray every day!
Let's spray every hour!  Let's have a insectside misters going 24
hours a day in the parks and in the schools!!!

In the TSA example, let's force every single traveller to strip naked
publically and be submitted to body cavity searches!  Since
**obviously** stopping terrorist bombs is so important that no other
considerations need to be taken into account.  Oh, and we should
obviously also give all of our financial information to the security
agencies so they can do futher screens to look for terrorists; who
cares about the risks that laptops with all of that unencrypted data
will be stolen out of a locked office in the San Francisco airport?

Similarly there are costs to doing all of this extra scanning.  You're
getting carried away here way you say that it never hurts to do extra
scanning, and that we don't need to decide whether or not it makes
sense to do it all.  That's just stupid.  The whole defense in depth,
taken to extremes, leads to completely nonsensical thinking.  Security
is *defintiely* a cost/benefit tradeoff, and to do something
meaningful here we need to think rationally about the threat
environment --- and part of that threat environment is the existing
security systems in Linux, which are definitely far more powerful than
what DOS/Windows have.

							- Ted
