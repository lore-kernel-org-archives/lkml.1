Return-Path: <linux-kernel-owner+w=401wt.eu-S934879AbXHGO5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879AbXHGO5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934795AbXHGO47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:56:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39352 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934780AbXHGO45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:56:57 -0400
Message-ID: <46B88836.5020604@garzik.org>
Date: Tue, 07 Aug 2007 10:56:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: James Bottomley <James.Bottomley@SteelEye.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
References: <1186248703.3439.20.camel@localhost.localdomain>	<alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>	<1186458941.6637.44.camel@localhost.localdomain>	<20070807001429.f8cb3b22.akpm@linux-foundation.org>	<1186496712.3414.17.camel@localhost.localdomain> <20070807155521.0dc9f068@the-village.bc.nu>
In-Reply-To: <20070807155521.0dc9f068@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I fully agree, and firmly believe that the current stabilisation works
>> incredibly well for shaking out bugs.  My problem is that it doesn't
>> work for stabilising features.  Either we have to get far more people
>> doing feature integration testing before the merge window, or we have to
>> accept feature updates after the merge window (for existing features
>> that are having stability issues).
> 
> The other alternative is that if Linus won't take updates you ask him to
> revert bsg so that you don't get a half baked merge as a result of this.
> I'm not sure that is a good path to follow either however.

Like everything else in life, it's a balance.  If something is clearly 
half-baked and requires a bunch of post-rc1 changes just to be usable, a 
revert might make a lot of sense.

It's questions of: how much further change is required, how invasive are 
those changes, how half-baked and incomplete is the feature really, what 
is the downside of a revert, ...

	Jeff



