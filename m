Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZINLGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZINLGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZINLGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:06:51 -0400
Received: from senator.holtmann.net ([87.106.208.187]:50834 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZINLGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:06:51 -0400
Subject: Re: [GIT] HID patches for 2.6.32 merge window
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0909141210590.17028@wotan.suse.de>
References: <alpine.LNX.2.00.0909132014310.17028@wotan.suse.de>
	 <1252922794.3421.3.camel@localhost.localdomain>
	 <alpine.LNX.2.00.0909141210590.17028@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 04:06:48 -0700
Message-Id: <1252926408.3421.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > > could you please pull from 'for-linus' branch of
> > > 
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
> > > 
> > > to receive HID patches accumulated for 2.6.32 merge window.
> > 
> > I am missing the patch to free the transport drivers from having to
> > manually disconnect hidinput and hidraw. All the hid->claimed handling
> > should really be hidden from the transport drivers.
> 
> Hi Marcel,
> 
> right, thanks for spotting this. The patch below has been rotting in my 
> 'waiting-for-ack' queue for quite some time. I was apparently waiting for 
> your Ack for the drivers/net/bluetooth part, and forgot about it when it 
> didn't come.
> 
> If you're OK with that, I'll include it in the next pile. Thanks.

you need to redo it against the net-next-2.6 tree or wait until Linus
merged that one. Otherwise it will clash with a temporary solution that
I already pushed some time ago.

Regards

Marcel


