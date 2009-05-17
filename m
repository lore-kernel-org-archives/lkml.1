Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZEQWBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZEQWBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 18:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZEQWBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 18:01:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:42184 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbZEQWBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 18:01:35 -0400
Subject: Re: [PATCH] [PowerPC] Support For Initrd Loaded Into Highmem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wolfgang Denk <wd@denx.de>
Cc: Konstantin Baydarov <kbaidarov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090517133417.9E0FC832E416@gemini.denx.de>
References: <4A103EDF.7050108@ru.mvista.com>
	 <20090517133417.9E0FC832E416@gemini.denx.de>
Content-Type: text/plain
Date: Mon, 18 May 2009 07:56:17 +1000
Message-Id: <1242597377.18075.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >   How Solved:
> > Code was added that checks if initrd is in the highmem and relocates initrd
> > into lowmem if required.
> 
> I don't think this is needed. Just don't load the ramdisk to highmem
> in the first place.

Well, it does make some sense to avoid the kernel eating itself if
passed things out of lowmem in the reserve map, though Konstantin patch
doesn't fix that properly, I think it's still something to look into.

Cheers,
Ben.


