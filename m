Return-Path: <linux-kernel-owner+w=401wt.eu-S1032103AbXEHU40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032103AbXEHU40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031801AbXEHU4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:56:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36711 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031757AbXEHU4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:56:09 -0400
Message-ID: <4640E3BF.8080401@garzik.org>
Date: Tue, 08 May 2007 16:55:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: penberg@cs.helsinki.fi, linville@tuxdriver.com, dcbw@redhat.com,
       hch@infradead.org, linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
References: <20070507141143.GB5125@tuxdriver.com>	<463F443A.5000306@garzik.org>	<84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com> <20070508.132737.104034594.davem@davemloft.net>
In-Reply-To: <20070508.132737.104034594.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Pekka Enberg" <penberg@cs.helsinki.fi>
>> On 5/7/07, Jeff Garzik <jeff@garzik.org> wrote:
>>> Open source is about release early, release often.  Not "hide code in a
>>> dark corner until Christoph thinks it is perfect."  We have high
>>> standards for upstream merged code, but that standard is not perfection.
>> Please. This has nothing to do with Christoph. (1) the driver seems to
>> break every Linux coding style convention known to man and (2) adds a
>> new ABI with bunch of ioctls() that apparently haven't been reviewed
>> properly. That's just not acceptable for mainline kernel!

> I completely agree, these things should be corrected and if the the
> author is being totally unresponsive to Christoph's review that's even
> worse.

Um, the maintainer replied yesterday morning[1] that libertas-2.6.git 
has already been updated for these requests, will be updated some more, 
and overall was responsive to the entire list of Christoph requests.

I'm mainly concerned with removing the unnecessary ioctls before 2.6.22 
release, since that affects userspace.  The vast majority of other stuff 
is cosmetic, which is being worked on, but lower priority in my book.

	Jeff


[1] Message-ID <1178539423.3032.24.camel@localhost.localdomain>
