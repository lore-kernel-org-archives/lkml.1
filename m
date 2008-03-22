Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYCVSjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYCVSjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYCVSj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:39:26 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:39253 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753017AbYCVSjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:39:25 -0400
X-Trace: 690579445/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAFACLv5EdRAVlC/2dsb2JhbACBW6Yy
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast
	Visual Memory Unit
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: dwmw2 <dwmw2@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-sh <linux-sh@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Paul Mundt <lethal@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
In-Reply-To: <20080322183200.GD19347@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain>
	 <1206209035.6324.29.camel@localhost.localdomain>
	 <20080322183200.GD19347@logfs.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 22 Mar 2008 18:39:07 +0000
Message-Id: <1206211147.6324.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-22 at 19:32 +0100, Jörn Engel wrote:
> On Sat, 22 March 2008 18:03:55 +0000, Adrian McMenamin wrote:
> > 

> Without a doubt, buffering is useful.  However I question how useful it
> is to implement this in individual device drivers instead of once in
> mtd_core.c.


Well, it's obviously useful to this device. Are you making best the
enemy of better?


> 
> Given that you have ignored most of my previous comments, NAK. 


Not good enough, frankly. What comments have I ignored? I didn't
implement your suggestion that a void* memory type become be32* because
it was totally inappropriate for a type that is passed in both be32 and
le32 and as u8.


>  I don't
> mind merging code that isn't up to our standards yet.  But I have a bad
> feeling about a maintainer that does not understand review comments.
> Since you had similar problems understanding Andrew, part of the blame
> may sit on your side.
> 

I'm sorry that you feel that way, but as you took the hump when I said
that this:

"Possibly the big-endian annotations need to trickly though the layers
here as well."

Isn't good english (and it's not) and asked you - twice - to explain
what you meant. I cannot accept your summary.


Adrian

