Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbXDBEKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbXDBEKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 00:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXDBEKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 00:10:46 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:2332 "EHLO
	asav00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbXDBEKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 00:10:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAG4fEEZKhRO4UGdsb2JhbACHO4hCAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: usb hid: reset NumLock
Date: Mon, 2 Apr 2007 00:10:47 -0400
User-Agent: KMail/1.9.3
Cc: Pete Zaitcev <zaitcev@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       stuard_hayes@dell.com
References: <20070330105924.01a16dd6.zaitcev@redhat.com> <84144f020704010449w2ba342a3qf3025425e84ad2ce@mail.gmail.com>
In-Reply-To: <84144f020704010449w2ba342a3qf3025425e84ad2ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020010.48991.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Sunday 01 April 2007 07:49, Pekka Enberg wrote:
> On 3/30/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> > Dell people (Stuart and Charles) complained that on some USB keyboards,
> > if BIOS enables NumLock, it stays on even after Linux has started. Since
> > we always start with NumLock off, this confuses users. Quick double dab
> > at NumLock fixes it, but it's not nice.
> 
> What I am seeing on my Thinkpad is that when I boot _without_ an USB
> keyboard NumLock is enabled. Switching to virtual console and back to
> X fixes it which is why I have never bothered to debug it further.
> Perhaps this is related? Should I give your patch a spin to see if it
> fixes the problem?
> 

Are you saying that NumLock LED is lit or that keyboard is in NumLock
state? Does the same happen if you boot with init=/bin/bash?

-- 
Dmitry
