Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbZL0WXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbZL0WXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 17:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZL0WXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 17:23:37 -0500
Received: from www84.your-server.de ([213.133.104.84]:45275 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZL0WXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 17:23:36 -0500
Subject: Re: [PATCH] [6/6] kfifo: Document everywhere that size has to be
 power of two
From: Stefani Seibold <stefani@seibold.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
In-Reply-To: <20091227221438.GA16353@core.coreip.homeip.net>
References: <200912271003.631128760@firstfloor.org>
	 <20091227210316.B116EB17C3@basil.firstfloor.org>
	 <1261950632.25298.33.camel@wall-e>
	 <20091227221438.GA16353@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 27 Dec 2009 23:23:31 +0100
Message-ID: <1261952611.25298.37.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 27.12.2009, 14:14 -0800 schrieb Dmitry Torokhov:
> On Sun, Dec 27, 2009 at 10:50:32PM +0100, Stefani Seibold wrote:
> > Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> > > On my first try using them I missed that the fifos need to 
> > > be power of two, resulting in a runtime bug. Document that requirement
> > > everywhere (and fix one grammar bug)
> > > 
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > 
> > 
> > Acked: Stefani Seibold <Stefani@Seibold.net>
> > 
> 
> Now, does it really _have_ to be this way? For record-oriented
> FIFO's it is customary to be 2*pow(n)*sizeof(rec) which is rarely
> 2*pow(m).
> 

Right. This is why i wrote the new macro base kfifo API, where i am able
to do this in that way.

Stefani


