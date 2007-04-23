Return-Path: <linux-kernel-owner+w=401wt.eu-S1161219AbXDWSiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbXDWSiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161218AbXDWSiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:38:06 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:39976 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161255AbXDWSiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:38:04 -0400
Date: Mon, 23 Apr 2007 14:38:03 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Roberto De Ioris <roberto@unbit.it>
cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] UidBind LSM 0.1
In-Reply-To: <1177318451.20613.8.camel@hagrid>
Message-ID: <Pine.LNX.4.64.0704231435430.15351@mtl.rackplans.net>
References: <1177318451.20613.8.camel@hagrid>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Roberto De Ioris wrote:
> Hi all,
> this is a very simple module that allows bind() to tcp/udp port (>=1024)
> only for the uids defined in a configfs tree.
> 
> It is a first version, it only works for PF_INET sockets and makes no
> difference between tcp and udp (i am working on this)
> 
> For (little) more info see 
> 
> http://projects.unbit.it/uidbind/
> 
> Patch attached is for vanilla 2.6.20.7

Is it possible to lock a range of ports to a uid?  

Also, is it possible to lock a uid to one ip address?  For example usera 
can only bind to 10.0.0.23 while userb can only bind to 10.0.0.24. 

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
