Return-Path: <linux-kernel-owner+w=401wt.eu-S1423239AbXEEJfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423239AbXEEJfJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 05:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423241AbXEEJfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 05:35:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423239AbXEEJfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 05:35:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] suspend/resume debugging: device filter
Date: Sat, 5 May 2007 11:39:32 +0200
User-Agent: KMail/1.9.5
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@osdl.org>, linux-pm@lists.osdl.org
References: <20070125110501.GA25151@elte.hu> <20070126015536.GA14917@suse.de> <20070505092425.GA23125@elte.hu>
In-Reply-To: <20070505092425.GA23125@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705051139.33008.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 May 2007 11:24, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > Here's a (compile tested only) patch that does this on a per-device 
> > basis, which is smaller, and should work just as well as your patch.
> > 
> > It creates a new file in the power/ directory for every device called 
> > "can_suspend".  Write a '0' to it to prevent that device from being 
> > suspended.
> > 
> > Does this work for you?
> 
> yeah, i was able to use this too to debug suspend/resume problems. But 
> i've added the check to the resume path too - for example sw-suspend 
> does a resume of devices during its suspend cycle, cutting off much of 
> the netconsole output.
> 
> which makes the can_suspend flag mis-named - perhaps rename it to 
> exclude_pm ?
> 
> updated patch below, against v2.6.21. Could we get this into v2.6.22 
> please? It's a real time-saver.

ACK

Greetings,
Rafael
