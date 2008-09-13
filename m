Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYIMCXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYIMCXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 22:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYIMCWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 22:22:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2228 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755099AbYIMCWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 22:22:54 -0400
Date: Fri, 12 Sep 2008 22:22:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       <me@bobcopeland.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <bogdano@mandriva.com.br>,
       <lcapitulino@mandriva.com.br>, <draconux@gmail.com>,
       <dlallement@mandriva.com>, <pterjan@mandriva.com>, <axboe@kernel.dk>
Subject: Re: Partition check considered as error is breaking mounting in
 2.6.27
In-Reply-To: <200809121646.09641.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0809122222120.16077-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, David Brownell wrote:

> On Friday 12 September 2008, Andrew Morton wrote:
> >                         printk(KERN_ERR " %s: p%d exceeds device capacity\n",
> >                                 disk->disk_name, p);
> > -                       continue;
> >                 }
> 
> So that now deserves to be KERN_WARN not KERN_ERR, yes?

In addition it deserves to be commented so that somebody doesn't go and 
change it yet again.

Alan Stern

