Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZB0RKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZB0RKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 12:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZB0RKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 12:10:32 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:55155 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZB0RKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 12:10:31 -0500
Message-ID: <49A81E59.6010105@nortel.com>
Date: Fri, 27 Feb 2009 11:09:45 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Arve Hj?nnev?g <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
References: <200902191356.53584.rjw@sisk.pl> <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org> <20090222140311.GF1387@ucw.cz> <200902231504.27879.oliver@neukum.org> <20090227101818.GH4582@elf.ucw.cz>
In-Reply-To: <20090227101818.GH4582@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2009 17:09:49.0336 (UTC) FILETIME=[32837180:01C998FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2009-02-23 15:04:22, Oliver Neukum wrote:

>> We can just as well have a class of tasks less important than power
>> saving. They'd just run when power saving is not active for some other
>> reason. Just like other such schemes we end up with the problem
>> of priority inversion with locking.
> 
> Ok, I guess this could be interesting in some cases... maybe. What are
> real examples of such tasks?

Some people might put casual system monitoring tools into this 
category--top, xload, gkrellm, xclock, etc.

It'd be nice if the animated banner ad in my web browser could be 
treated this way. :)

Chris
