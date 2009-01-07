Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbZAGUkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbZAGUkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZAGUjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:39:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43808
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752931AbZAGUjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:39:52 -0500
Date: Wed, 07 Jan 2009 12:39:54 -0800 (PST)
Message-Id: <20090107.123954.257436361.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: jaswinder@infradead.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH -net-next 1/4] firmware: convert e100 driver to
 request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <9929d2390901071023s590f439fre15696786f098b81@mail.gmail.com>
References: <9929d2390901041820h4cf51e2h3612108c516b6869@mail.gmail.com>
	<20090104.213402.12464178.davem@davemloft.net>
	<9929d2390901071023s590f439fre15696786f098b81@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Date: Wed, 7 Jan 2009 10:23:44 -0800

> The only testing that we were not able to do was the IPMI testing,
> because of the lack of resources.  All other testing passed.
> 
> While all other testing passed, I am concerned about not being able to
> test whether or not this change affects the ability to pass IPMI
> traffic.  I am not sure if the "gain" of using request_firmware() out
> weighs the potential risk that IPMI traffic may be broken with this
> patch.  I guess I wondering what the gain is in using the
> request_firmware() function?
> 
> >From past experience with IPMI traffic and the e100, the loading of
> the microcode in the correct manner greatly affected whether IPMI
> traffic would pass or not.

Jeff, I've lost all of my patience.

All drivers are being converted this way.  I fought against doing it
to tg3 for various reasons, but the tide worked against me and I
accepted that.

We can't hold this patch up forever for a potential problem that you
don't have the resources to even test for more than a week.

I'm therefore adding this patch, and we'll fix or revert if the
"possible" IPMI problems do surface.
