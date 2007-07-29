Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbXG2JYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbXG2JYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760750AbXG2JYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:24:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:26834 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759586AbXG2JYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UGkYGzjUvq+GdzShwchMi9F4lKBQWZKi15XKohRpBGfx2JGT60hc97huAEPDnZMFxWp0Am3UukhJIENMFpsCwyFKKbBqttmgjcCDCS3uMZtzKGnHEhd/QAGGJRlfVgXZsTORD9zjdH5smFb+E7xSkr3RgemVch7b+8YVLczGo7M=
Date: Sun, 29 Jul 2007 10:24:02 +0100
From: Xudong Guan <xudong.guan@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070729092402.GA2272@xguan-laptop>
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com> <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com> <20070729085059.GA10758@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729085059.GA10758@gollum.tnic>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Thu, Jul 26, 2007 at 09:31:54PM -0700, H. Peter Anvin wrote:
> > If we can't reproduce the problem in simulation, that itself will tell
> > us something very important.  If we *can* reproduce it in simulation, it
> > will be vastly easier to debug.
> 
> [boris@gollum:10:34:25:qemu:9553)->  qemu -kernel /boot/2.6.22-4fd06960f120e02e9abc802a09f9511c400042a5-12 -append "root=/dev/hda" linux-0.2.img

You are using qemu itself as the kernel loader instead of your
possible problematic grub on your harddisk. To duplicate the problem,
you need to manually copy your grub and the kernel to linux-0.2.img
and boot it with "qemu linux-0.2.img", although I am not sure
exactly how to manually do this. Another way is to know your
installation media that contains the copy of grub you are using,
and use it to do an installation in qemu.

Xudong

