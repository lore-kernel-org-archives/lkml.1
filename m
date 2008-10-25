Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYJYO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYJYO73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYJYO7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:59:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3079 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751597AbYJYO7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:59:20 -0400
Date: Sat, 25 Oct 2008 10:59:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbcore: Limit number of 'unable to enumerate USB device'
 messages
In-Reply-To: <49028F9D.3020208@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.0810251058050.3569-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008, Larry Finger wrote:

> Greg KH wrote:
> > 
> > The latest tree should warn you if you load the host controller drivers
> > in the wrong order, so this shouldn't really be an issue anymore, right?
> 
> I have not seen such warhings, thus I expect loading is in the proper order.
> > 
> > Like Alan said, proper log messages would be helpful here.
> 
> Agreed, but I have no idea what I should be looking for. For the moment, I have
> lots of test prints looking for the sequence of events that lead to this
> spamming of the logs.

Just build your test kernel with USB debugging enabled, and when you 
get that spamming, post the complete dmesg log.

Alan Stern

