Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbXEWVJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbXEWVJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbXEWVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:09:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37089 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXEWVJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:09:48 -0400
Message-ID: <4654AD91.1030808@pobox.com>
Date: Wed, 23 May 2007 17:09:37 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
References: <4635510D.4060103@shaw.ca> <200705231349.56976.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org> <200705231403.24439.jbarnes@virtuousgeek.org>
In-Reply-To: <200705231403.24439.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Apparently Vista will move away from using type 1 config space accesses 
> though, so if we keep using it, we'll probably run into some lame board 

Yep.


> that assumes you're using mmconfig at some point in the near future.  
> But then again, we're often on that less tested path (e.g. with ACPI), 
> so maybe that doesn't matter much.

One of the reasons why hardware vendors want to move away from 
traditional accesses is to be able to use the larger config space in 
PCI-Express, rather than being locked into the 256-byte legacy PCI 
config space.

Several modern PCI-Express devices utilize the upper config space, but 
due to legacy reasons the registers are usually ones that do not require 
OS drivers to know about (like BIST stuff or diagnostic registers).

Expect that to change, as MS shakes out the bugs (or maybe we are doing 
their job for them?).

	Jeff


