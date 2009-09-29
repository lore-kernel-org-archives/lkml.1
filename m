Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZI2NbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZI2NbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 09:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZI2NbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 09:31:22 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:42321 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZI2NbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 09:31:21 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 29 Sep 2009 15:31:23 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291456.56723.borntraeger@de.ibm.com> <20090929130950.GA23395@amit-x200.redhat.com>
In-Reply-To: <20090929130950.GA23395@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291531.23389.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 September 2009 15:09:50 schrieb Amit Shah:
> Great, thanks. However I was thinking of moving this init to the probe()
> routine instead of in the init_conosle routine just because multiple
> consoles can be added and we don't want to init this each time.. just
> once in probe is fine.

If you have new patch CC me and I can give it a spin.


> > I am a bit reluctant to Ack the whole change, since my preference would
> > have been to not merge virtio serial/console and instead keeping both
> > separate. We have already managed to clutter all other virtio drivers
> > with tons of configuration stuff and feature bits - and every driver uses
> > a different model for configuration and commands (feature bits, config
> > space, config_change indication, extra config virtqueue, commands
> > embedded into the data....). Using a different device ID for a different
> > use seem like a better way to me.
> 
> Well, Anthony described your objection as a comment in passing and that
> you weren't strongly against merging the two drivers when I brought up
> your argument sometime back.
> 
> Also, it was difficult to make progress and just keep fighting about
> these issues. So even though I didn't like merging the stuff, I had to.

Sure, you were caught between two stools... I have to admit that I dropped of 
this discussion and did not follow up - I simply considered my wedding and 
honeymoon more important ;-)

I still belive that I am right and Anthony is wrong about this  8-), but if 
merging is the way to go - so be it. 
