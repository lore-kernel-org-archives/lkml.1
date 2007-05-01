Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbXEAQQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbXEAQQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXEAQQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:16:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbXEAQQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:16:14 -0400
Message-ID: <46376748.6020408@redhat.com>
Date: Tue, 01 May 2007 12:14:00 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jeff Garzik <jeff@garzik.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] to something appropriate (was Re: 2.6.22 -mm merge	plans)
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <46368062.6000100@garzik.org> <20070430170919.45e4b42b.akpm@linux-foundation.org> <463688AD.1050903@garzik.org> <20070501004036.GS2819@sequoia.sous-sol.org> <46368DA5.7070003@garzik.org> <20070501045806.GA3697@kroah.com>
In-Reply-To: <20070501045806.GA3697@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Apr 30, 2007 at 08:45:25PM -0400, Jeff Garzik wrote:
>> Chris Wright wrote:
>>> 2) you can add them
>>> runtime in userspace (and for pcmcia too after patch in question is
>>> applied), so we've historically avoided that kind of patch for -stable.
>>
>> Due to distro installer environments, and very poor support for making 
>> dynamic PCI IDs persistent once added, what you describe is more of a 
>> goal than reality.
> 
> But distros can easily add the device id to their kernel if needed, it
> isn't something that the -stable tree shoud be accepting.  Otherwise, we
> will be swamped with those types of patches...
> 

Oh sure, leave the distros swamped with them instead. :)

And they all have to do it separately, meaning they don't stay in sync
and they duplicate each other's work...

