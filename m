Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbZCXSMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbZCXSMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZCXSMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:12:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46938 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbZCXSMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:12:22 -0400
Date: Tue, 24 Mar 2009 14:12:03 -0400
From: Bill Nottingham <notting@redhat.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Scott James Remnant <scott@ubuntu.com>, netdev@vger.kernel.org,
       linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
Message-ID: <20090324181202.GE5925@nostromo.devel.redhat.com>
Mail-Followup-To: Matt Domsch <Matt_Domsch@dell.com>,
	Scott James Remnant <scott@ubuntu.com>, netdev@vger.kernel.org,
	linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090324154617.GA16332@auslistsprd01.us.dell.com> <1237914139.22009.18.camel@quest> <20090324175203.GB22700@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324175203.GB22700@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch (Matt_Domsch@dell.com) said: 
> > Now consider USB.  Would the device name change depending on which USB
> > port you plugged it into?  Or is USB just a single slot, in which case
> > what happens when you have two USB ethernet devices?
> > 
> > The Apple USB Ethernet device in my iPhone is not the USB Wireless
> > adapter I own, both have very different networking configurations.
> 
> we would obviously need a solution.  eth_usb_{something} perhaps.

Right, but having biosdevname chase each new bus that comes along
sounds iffy. I'd prefer /dev/net/by-name symlinks, if at all
possible. But that's a lot of code that I'm not prepared to write.

Bill
