Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbXA2WvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbXA2WvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXA2WvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:51:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:52302 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbXA2WvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lXK3DyX1KheXgq5WajqITAycRskn96K5UIaQNwlwHRy5tst113fMSRtgSMDJW4Hr8Q3KVX9wGIrDCk+6Eqgc6JmI5fWbGYkgBI8xxDlfgyIRD7+VsV2xIcjG5r0zDlR6oEncIWvXDQ7Q6Ufdi/7B1VTIdedvLNBZEsh2Jdm16Zk=
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: tglx@linutronix.de
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <1170110732.29240.59.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <1169931333.17469.125.camel@localhost.localdomain>
	 <20070129113159.7ad22e4c@freekitty>
	 <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <1170110318.21603.25.camel@funkylaptop>
	 <1170110732.29240.59.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Mon, 29 Jan 2007 23:50:56 +0100
Message-Id: <1170111056.21603.30.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 janvier 2007 à 23:45 +0100, Thomas Gleixner a écrit :
> On Mon, 2007-01-29 at 23:38 +0100, Frédéric Riss wrote:
> > I see the same symptoms on my Intel Mac Mini, and reverting the commit
> > also allows the driver to seemingly resume correctly. 
> > 
> > However after coming out of sleep I need to reconfigure the network
> > interface. No need to rmmod/insmod, just ifdown/ifup is sufficient (but
> > of course shouldn't be necessary, should it?). If I don't reconfigure
> > it, ping from/to the box will work, but nothing more complicated like
> > ssh will go through.
> 
> That's probably a userspace problem. Are you using DHCP ?

Yep DHCP. Is that a known issue? I never had to reconfigure with older
kernels.

Fred.

