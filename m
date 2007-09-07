Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbXIGGOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbXIGGOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 02:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXIGGOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 02:14:11 -0400
Received: from 184.5.221.87.dynamic.jazztel.es ([87.221.5.184]:49803 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750824AbXIGGOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 02:14:10 -0400
Date: Fri, 7 Sep 2007 08:14:11 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] ELAN U132 Host Controller Driver: convert sw_lock
	to mutex
Message-ID: <20070907061411.GF3081@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Oleg Verych <olecom@flower.upol.cz>, gregkh@suse.de,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070906210922.GC3081@traven> <20070906211815.GD3081@traven> <E1ITPWc-0004rC-Kr@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ITPWc-0004rC-Kr@flower>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, Sep 07, 2007 at 12:08:34AM +0200 Oleg Verych ha dit:

> * Thu, 6 Sep 2007 23:18:15 +0200
> 
> []
> > @@ -184,7 +184,7 @@ struct u132_ring {
> >  struct u132 {
> 
> Subject: [PATCH 1/2] ELAN U132 Host Controller Driver: convert sw_lock to mutex
> []
> >          struct list_head u132_list;
> > -        struct semaphore sw_lock;
> > +        struct mutex sw_lock;
> >          struct semaphore scheduler_lock;
> 
> Subject: [PATCH 2/2] ELAN U132 Host Controller Driver: convert  scheduler_lock t
> []
> >         struct list_head u132_list;
> >         struct semaphore sw_lock;
> >-        struct semaphore scheduler_lock;
> >+        struct mutex scheduler_lock;
> 
> Are you sure, you have right patch sequence?

my idea was to sent two independent patches, would it be better to
have one patch based on the other?

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              Insanity: doing the same thing over and over
                again and expecting different results
                            (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
