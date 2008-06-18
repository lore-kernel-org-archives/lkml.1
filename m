Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYFRXbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYFRXbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYFRXbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:31:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:33418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbYFRXbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:31:43 -0400
Subject: Re: Request for discussion on when to merge drivers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1213802866.3515.24.camel@localhost.localdomain>
References: <1213802866.3515.24.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 09:31:34 +1000
Message-Id: <1213831894.8011.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The only slight wrinkle (at least for me) is that often the process of
> cleaning up a driver is fairly intensive for a maintainer and turn
> around is a lot faster if you're doing it in a tree you control.  (All
> the scsi drivers we've done like this have lived in temporary branches
> while they were being worked on).  So perhaps in addition we should be
> encouraging maintainers to run staging branches under similar rules in
> the staging tree, but allowing inclusion into linux-next?

 .../...

linux-next should, imho, exclusively be for things we are pretty much
commited to merge in the next release. ie, a staging place to fixup
things like build breakages, patch conflicts, etc...

Or else, it will just be another -mm ....

So while what you say makes sense, I think we should only put drivers in
once we have pretty much decided that the drivers in question would be
merged... in which case, why not straight upstream ?

Cheers,
Ben.


