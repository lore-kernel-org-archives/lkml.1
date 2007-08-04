Return-Path: <linux-kernel-owner+w=401wt.eu-S1765216AbXHDQpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765216AbXHDQpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764384AbXHDQoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:44:55 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38297 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764167AbXHDQox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:44:53 -0400
Date: Sat, 4 Aug 2007 20:44:39 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage.
Message-ID: <20070804164438.GC14175@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708031741.18404.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708031741.18404.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel.
> On Tuesday 31 July 2007 10:13, Evgeniy Polyakov wrote:
> >     * storage can be formed on top of remote nodes and be exported
> > 	simultaneously (iSCSI is peer-to-peer only, NBD requires device
> > 	mapper and is synchronous)
> 
> In fact, NBD has nothing to do with device mapper.  I use it as a 
> physical target underneath ddraid (a device mapper plugin) just like I 
> would use your DST if it proves out.

I meant to create a storage on top of several nodes one needs to have
device mapper or something like that on top of NBD itself. To further
export resulted device one needs another userspace NDB application and 
so on. DST simplifies that greatly.

DST original code worked as device mapper plugin too, but its two 
additional allocations (io and clone) per block request ended up for me 
as a show stopper.

-- 
	Evgeniy Polyakov
