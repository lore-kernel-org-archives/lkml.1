Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZHGPvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZHGPvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZHGPvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:51:40 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:52595 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZHGPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:51:40 -0400
Message-ID: <4A7C4D6C.6050101@nortel.com>
Date: Fri, 07 Aug 2009 09:51:08 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Al Boldi <a1426z@gawab.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
References: <20090805171513.GA10443@kroah.com> <200908070703.40706.a1426z@gawab.com> <20090807042544.GA24299@kroah.com> <200908070804.08156.a1426z@gawab.com> <20090807052015.GA24615@kroah.com>
In-Reply-To: <20090807052015.GA24615@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2009 15:51:09.0135 (UTC) FILETIME=[E18FADF0:01CA1776]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Aug 07, 2009 at 08:04:08AM +0300, Al Boldi wrote:

>> The question is, how fast can devtmpfs get the device list from the kernel on 
>> bootup?  How much faster than udev?  How much slower than static /dev?
> 
> It's much faster than udev, and is equivalent to a static /dev with the
> exception that the group and permission settings that you are used to.
> udev then needs to come along and make those settings, but that's so
> frickin fast it's amazing.

Earlier in the thread you indicated a 0.5sec speedup over udev.  Is that
really considered "much faster"?

I do agree that it makes sense to do this, but more from an elegance
view than a performance one.

Chris

