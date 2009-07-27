Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZG0N7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZG0N7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZG0N7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:59:16 -0400
Received: from kroah.org ([198.145.64.141]:43232 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZG0N7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:59:13 -0400
Date: Mon, 27 Jul 2009 06:58:22 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: "Matthew D. Reuther" <mreuther@joust.gpcc.itd.umich.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: android lowmemorykiller breaks compile
Message-ID: <20090727135822.GA9037@kroah.com>
References: <4A6CE261.mailHX41REN0Z@joust.gpcc.itd.umich.edu>
 <alpine.DEB.2.00.0907261630420.17123@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907261630420.17123@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 04:33:57PM -0700, David Rientjes wrote:
> On Sun, 26 Jul 2009, Matthew D. Reuther wrote:
> 
> > I don't actually use Android, but I compile it just for giggles. With every one of the 2.6.31-rc releases, my compile breaks when it hits lowmemorykiller:
> > 
> > drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
> > drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'
> > make[3]: *** [drivers/staging/android/lowmemorykiller.o] Error 1
> > make[2]: *** [drivers/staging/android] Error 2
> > 
> > Maybe this should not be selectable for x86? Can't tell.
> > 
> 
> It's had a fix pending in Greg KH's staging tree for a couple months, 
> we're just waiting for it to be pushed to Linus.  Greg indicated he will 
> send it in his next staging pull.

Yes, sorry, was on vacation, will go to Linus in a day or so.

thanks for your patience,

greg k-h
