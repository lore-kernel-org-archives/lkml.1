Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZCaUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZCaUTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZCaUSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:18:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45485 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZCaUSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:18:50 -0400
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
From: Andi Kleen <andi@firstfloor.org>
References: <20090331184057.28333.77287.stgit@dev.haskins.net>
Date: Tue, 31 Mar 2009 22:18:43 +0200
In-Reply-To: <20090331184057.28333.77287.stgit@dev.haskins.net> (Gregory Haskins's message of "Tue, 31 Mar 2009 14:42:47 -0400")
Message-ID: <87ab71monw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins <ghaskins@novell.com> writes:

What might be useful is if you could expand a bit more on what the high level
use cases for this. 

Questions that come to mind and that would be good to answer:

This seems to be aimed at having multiple VMs talk
to each other, but not talk to the rest of the world, correct? 
Is that a common use case? 

Wouldn't they typically have a default route  anyways and be able to talk to each 
other this way? 
And why can't any such isolation be done with standard firewalling? (it's known that 
current iptables has some scalability issues, but there's work going on right
now to fix that). 

What would be the use cases for non networking devices?

How would the interfaces to the user look like?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
