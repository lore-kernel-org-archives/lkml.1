Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYAFRLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYAFRLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYAFRLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:11:45 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1198 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757228AbYAFRLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:11:43 -0500
Date: Sun, 6 Jan 2008 12:11:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: david@lang.hm
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
In-Reply-To: <Pine.LNX.4.64.0801060652390.16883@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0801061206500.7367-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 david@lang.hm wrote:

> what sysadmins like me would really like is a set of scripts that could 
> generate a .config from an existing system. After we have one that covers 
> the hardware for the system we will then have a much better starting point 
> to work from. We may disable some drivers (sound drivers on a server for 
> example).

One thing is worth pointing out here.  If you do remove some drivers 
(like usb-storage), you may end up with a bloated configuration because 
the things they selected (like SCSI) won't get removed automatically.  
That's a disadvantage of using select.

Another disadvantage appears when somebody tries by hand to remove a 
component (like SCSI) and finds that it magically reappears.  Evidently 
something is selecting it, but there's no way to find out what.

Alan Stern

