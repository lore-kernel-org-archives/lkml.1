Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbZIQSw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbZIQSw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZIQSw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:52:57 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:35864 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZIQSw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:52:56 -0400
Date: Thu, 17 Sep 2009 20:52:57 +0200
Message-Id: <917360695@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [GIT PULL] DRBD for 2.6.32
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/5lRn7tR4sAcR3ZScObZ1zBaNjFuoETRzbmpLwqjxuDUq6L
 zdZ819tmh2oyQfNj+/3oVoumRx8eekpr7DKPqLeeR+fCy8SSOU=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so, no drbd for 2.6.32 because of "raid unification issues"?

why did no one tell that earlier ?

how long will that last?

ages?

somebody taking into consideration that decisions like these is scaring away good kernel developers ?

i was giving much hope on DRBD being merged in .32 , but given this i think i need to kick Linux and better spend bucks on winblowze & datacore for the storage-server undertaking..... (as i know that works and will be supported in the forseeable future)

or does someone know another good and intelligent storage replication solution i can trust ?

maybe pratima ? (http://www.linuxjournal.com/article/7265 ) 
or any of those several closed source linux products with those weird binary blobs which causing support and update headaches?
just kidding......

sorry, but i am NOT amused.

:-P



List:       linux-kernel
Subject:    Re: [GIT PULL] DRBD for 2.6.32
From:       Christoph Hellwig <hch () infradead ! org>
Date:       2009-09-17 16:11:09
Message-ID: 20090917161108.GA3361 () infradead ! org
[Download message RAW]

On Thu, Sep 17, 2009 at 10:02:45AM -0600, James Bottomley wrote:
> So I think Christoph's NAK is rooted in the fact that we have a
> proliferation of in-kernel RAID implementations and he's trying to
> reunify them all again.
> 
> As part of the review, reusing the kernel RAID (and actually logging)
> logic did come up and you added it to your todo list.  Perhaps expanding
> on the status of that would help, since what's being looked for is that
> you're not adding more work to the RAID reunification effort and that
> you do have a plan and preferably a time frame for coming into sync with
> it.

Yes.  RDBD has spend tons of time out of tree, and if they want to put
it in now I think requiring them to do their homework is a good idea.

Note that the in-kernel raid implementation is just a rather small part
of this, what's much more important is the user interface.  A big part
of raid unification is that we can support on proper interface to deal
with raid vs volume management, and DRBD adds another totally
incompatible one to that.  We'd be much better off adding the drbd in
the write protocol (at least the most recent version) to DM instead of
adding another big chunk of framework.


________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

