Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbXLTWDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbXLTWDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763649AbXLTWDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:03:43 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:50615 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762578AbXLTWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:03:42 -0500
Date: Thu, 20 Dec 2007 17:03:35 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code
 updated
In-Reply-To: <20071220212700.GB5808@kroah.com>
Message-ID: <alpine.LFD.0.9999.0712201659360.10061@localhost.localdomain>
References: <20071220003031.GA15129@kroah.com> <20071219223206.ada18362.randy.dunlap@oracle.com> <20071220212700.GB5808@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007, Greg KH wrote:

> How about:
> 	- A ktype is the type of object that embeds a kobject.

if i were reading the above for the first time, i would have no idea
what was being embedded where.  "embeds a kobject" where?  what's
being embedded in what?  that sentence doesn't make it clear.  what's
the current definition for a "struct kobject"?

>         Every structure that embeds a kobject needs a corresponding ktype.

and if it does, whose responsibility is it to provide one?  mine?
that's not clear.

> 	  The ktype controls what happens to the kobject when it is
> 	  created and destroyed.

i doubt that.   i wouldn't say that the ktype "controls" what happens,
i would say that it "defines" what happens.  to control suggests
active participation.

rday


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
