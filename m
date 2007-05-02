Return-Path: <linux-kernel-owner+w=401wt.eu-S1161196AbXEBJlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161196AbXEBJlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161000AbXEBJlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:41:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46015 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981AbXEBJlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:41:22 -0400
Message-Id: <1178098882.28231.1187661107@webmail.messagingengine.com>
X-Sasl-Enc: RO7fObmnDHrVHJ1Efe+6lGiT5A8Bzz4yYrk0bhT3yUwx 1178098882
From: "Tilman Schmidt" <tilman@imap.cc>
To: "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickins" <hugh@veritas.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
   <46338AEB.2070109@imap.cc>
   <20070428141024.887342bd.akpm@linux-foundation.org>
   <4636248E.7030309@imap.cc>
   <20070430112130.b64321d3.akpm@linux-foundation.org>
   <46364346.6030407@imap.cc>
   <20070430124638.10611058.akpm@linux-foundation.org>
   <46383742.9050503@imap.cc>
   <20070502001000.8460fb31.akpm@linux-foundation.org>
   <20070502074305.GA7761@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!     
   (-1)
In-Reply-To: <20070502074305.GA7761@suse.de>
Date: Wed, 02 May 2007 11:41:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 00:43:05 -0700, "Greg KH" <gregkh@suse.de> said:

> > > And the winner is:
> > > 
> > > gregkh-driver-driver-core-make-uevent-environment-available-in-uevent-file.patch
> > > 
> > > Reverting only that from 2.6.21-rc7-mm2 gives me a working kernel
> > > again.
> 
> Wait, even though this isn't good, it shouldn't have been hit by anyone,
> that file used to not be readable, so I doubt userspace would have been
> trying to read it...
> 
> Tilman, what version of HAL and udev do you have on your machine?

The ones that came with SuSE 10.0:

hal-0.5.4-6.4
udev-068git20050831-9

HTH
Tilman

PS: I'll test your patch and git-bisect when I'm back at the machine.
-- 
  Tilman Schmidt
  tilman@imap.cc

