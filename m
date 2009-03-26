Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbZCZUUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbZCZUUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZCZUT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:19:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50539 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbZCZUT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:19:56 -0400
Subject: Re: Network Device Naming mechanism and policy
From: Dan Williams <dcbw@redhat.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: David Miller <davem@davemloft.net>, Matt_Domsch@dell.com,
       netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <49CA927B.9080709@nortel.com>
References: <20090324154617.GA16332@auslistsprd01.us.dell.com>
	 <20090324.155756.214460004.davem@davemloft.net>
	 <49CA927B.9080709@nortel.com>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 16:17:42 -0400
Message-Id: <1238098662.3254.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 14:22 -0600, Chris Friesen wrote:
> David Miller wrote:
> > From: Matt Domsch <Matt_Domsch@dell.com>
> > Date: Tue, 24 Mar 2009 10:46:17 -0500
> > 
> >> Problem: Users expect on-motherboard NICs to be named eth0..ethN.
> >> This can be difficult to achieve.
> > 
> > I learned a long time ago that eth0 et al. have zero meaning.
> > 
> > If the system firmware folks gave us topology information with respect
> > to these things, we could export something that tools such as
> > NetworkManager, iproute2, etc. could use.
> 
> <snip>
> 
> > I guess it's easier to spew about MAC addresses and other
> > irrelevant topics than try to solve this problem properly. :-)
> 
> What about things like USB network adapters where the topology is not 
> fixed?  Presumably we would want to use some sort of unique identifier, 
> and the MAC comes to mind.  Of course, then you run into the problem of 
> how to deal with duplicate MACs.

USB devices do have a serial number field in the descriptors, but that
only sometimes gets populated with sensible values.  More often than not
it's just zeros.  But worth checking if the MAC isn't set yet.

Dan


