Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513Ab0AYRr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0AYRr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488Ab0AYRrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:47:55 -0500
Received: from kroah.org ([198.145.64.141]:44702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab0AYRry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:47:54 -0500
Date: Mon, 25 Jan 2010 09:46:25 -0800
From: Greg KH <greg@kroah.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Xiaotian Feng <dfeng@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [00/29] 2.6.32.6 stable review
Message-ID: <20100125174625.GA18033@kroah.com>
References: <20100123001145.GA7391@kroah.com>
 <20100123232152.4b88d1e3.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1001241727560.2906@localhost.localdomain>
 <4B5D5903.4000209@pardus.org.tr>
 <20100125171631.GB17421@kroah.com>
 <4B5DD76D.2050306@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B5DD76D.2050306@pardus.org.tr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 07:39:57PM +0200, Ozan Çağlayan wrote:
> Greg KH wrote:
> > On Mon, Jan 25, 2010 at 10:40:35AM +0200, Ozan Çağlayan wrote:
> 
> > 
> > Huh?  That says:
> > 	clockevents: Add missing include to pacify sparse
> > 
> > and does not sound like a problem that needs to be fixed for "real"
> > users, right?
> > 
> > Or does .32.6 have a build problem somewhere?
> 
> Applying the patch on top of 2.6.32.y causes build failure as the fix calls a macro from
> "tick-internal.h".
> 
> #include "tick-internal.h"
> 
> was added to clockevents.c with 8e1a928a2ed7e8 in linux-2.6/master for another reason e.g.
> the patch is OK for linux-2.6/master but should be modified to add #include directive
> for .32.y when backporting.

Hm, please, can someone give me _exactly_ which git commit ids they wish
to see in the .32-stable tree to resolve this issue?

thanks,

greg k-h
