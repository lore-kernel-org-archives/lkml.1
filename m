Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbYG2U6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbYG2U6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYG2U6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:58:31 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48919 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYG2U6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:58:31 -0400
Subject: Re: [PATCH] mISDN cleanup user interface
From: Marcel Holtmann <marcel@holtmann.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Karsten Keil <kkeil@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
In-Reply-To: <1217362946.27925.137.camel@pmac.infradead.org>
References: <20080729195637.GB25929@pingi.kke.suse.de>
	 <1217362946.27925.137.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 23:02:10 +0200
Message-Id: <1217365330.417.8.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten,

> > Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> > 
> > The channelmap should have the same size on 32 and 64 bit
> > systems. Thanks to David Woodhouse for spotting this.
> > 
> > Signed-off-by: Karsten Keil <kkeil@suse.de>
> 
> Er, isn't that still broken? Consider 32-bit userspace on 64-bit kernel,
> big-endian.

I agree with David here. Please lets not do these horribly things again.
Almost everybody has done their fair share of brokenness with the compat
layers. Especially 32-bit userspace on 64-bit kernels. Using __u32 and
alike is a way better choice and less headache.

Regards

Marcel


