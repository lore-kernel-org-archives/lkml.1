Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbZGGPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbZGGPnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZGGPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:43:41 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:60218 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbZGGPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:43:40 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Tue, 7 Jul 2009 10:43:35 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907071130550.8221-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907071130550.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071043.37550.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 7 2009, Alan Stern wrote:
> On Tue, 7 Jul 2009, Michael S. Zick wrote:
> 
> > Got it.
> > Anything that gives me something other than a dead machine
> > with a glowing power-on light is forward progress.
> > 
> > Will give this patch a try today and report back.
> > 
> > At the moment am running the machine without either USB driver loaded.
> > Just to see if they are contributing to the problems.
> 
> It looks like there's a serious problem in your UHCI hardware.  
> According to the log you posted, it's not working at all.
> 

I am using the x86-generic drivers - -

There are VIA-device specific drivers in other arch trees,
(arm?, powerpc?) - I haven't compared them to the x86-generic
to see if they had to do something specific for 1106:3038, 1106:3104

Any idea if those drivers are "long dead" or still in use?

Mike
> Of course, that's no excuse for an oops.
> 
> Alan Stern
> 
> 
> 


