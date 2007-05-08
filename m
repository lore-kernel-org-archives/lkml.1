Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXEHI27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXEHI27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXEHI27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:28:59 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:30563 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755470AbXEHI26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:28:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=OpetctNsK8La0+GclSJRkbxel0D21uC/nvgs5p60mGZQuUT4Yll5s8HSp1CF13vfpii4sKPAS24VKYx6N4xfJqa39d/Ymgk3EPecwHSIMCI/zWzSfbhZCTXnMjgjowC2pq3O+6HgjPgoSJKfeTgOFZG5GdwxpdxvQjBkFI4m1uU=  ;
X-YMail-OSG: MGeqcWoVM1lPYeEsKPyPyKRXvIwRBsXof0y.Zh1XQmiLo00kmNdP4w.JZyQdTG31qO02iLDUrA--
Message-ID: <464034C2.3030007@yahoo.com.au>
Date: Tue, 08 May 2007 18:28:50 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Jeff Garzik <jeff@garzik.org>, "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6 (was Re:
 Please pull 'libertas' branch of wireless-2.6)
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070507104117.GA31601@infradead.org> <1178539423.3032.24.camel@localhost.localdomain> <20070507141143.GB5125@tuxdriver.com> <463F443A.5000306@garzik.org> <20070508061255.GT11166@waste.org>
In-Reply-To: <20070508061255.GT11166@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, May 07, 2007 at 11:22:34AM -0400, Jeff Garzik wrote:

>>For my part, I _did_ review it.  Twice.  Once in the early days, and 
>>once when I pulled it into my netdev-2.6.git tree.  libertas needs the 
>>changes mentioned in this thread.  But the driver is in workable shape 
>>to be USED while being improved.  I strongly dislike people being cowed 
>>into not merging a driver for years, because the driver in question does 
>>not meet Christoph's idea of perfection.
> 
> 
> It's a shame to expose new ABI bits that we expect to change to
> mainline. Getting rid of obsolete interfaces is next to impossible so
> the introduction of new interfaces really does warrant serious
> consideration.
> 
> Can we come up with a scheme to keep the new ioctls introduced by this
> driver from leaking over into distro-land before they get reworked?
> Like preemptively adding a deprecation printk?

And it isn't only ioctls, but just having code there to set a bad
example, and added overhead of maintaining APIs used by the
driver.

Two things on top of a lot of people's pet peeves list are lack of
good review bandwidth, and poor driver code! So it is sad this was
merged without Christoph's comments being addressed. "it works for
me, we can fix it later" is probably a big reason for quality
problems of some parts of the kernel.

As for Christoph's idea of perfection... it usually isn't a bad
thing. And he is quite reasonable if you explain your good reason
to disagree or do something differently. The attitude of ignoring
comments can be really demotivating for a reviewer.

-- 
SUSE Labs, Novell Inc.
