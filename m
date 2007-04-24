Return-Path: <linux-kernel-owner+w=401wt.eu-S1423032AbXDXUNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423032AbXDXUNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423018AbXDXUNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:13:36 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:52817 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423032AbXDXUNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:13:35 -0400
Date: Tue, 24 Apr 2007 16:13:34 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Roberto De Ioris <roberto@unbit.it>
cc: linux-security-module@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] UidBind LSM 0.2
In-Reply-To: <1177425262.6547.24.camel@hagrid>
Message-ID: <Pine.LNX.4.64.0704241610120.21879@mtl.rackplans.net>
References: <1177425262.6547.24.camel@hagrid>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Roberto De Ioris wrote:

> Hi all,
> 
> this is the second release for UidBind LSM:
> 
> http://projects.unbit.it/uidbind/
> 
> UidBind allows call to bind() function only to the uid defined in a
> configfs tree.
> 
> It is now possible to specify different uid (for the same port) on
> different ipv4 addresses:
> 
> mkdir uidbind/8081
> mkdir uidbind/8081/192.168.1.17
> mkdir uidbind/8081/192.168.1.26
> echo 1017 > uidbind/8081/192.168.1.17/uid
> echo 1026 > uidbind/8081/192.168.1.26/uid
> 
> This version even fix some leek in version 0.1
> 
> Patch attached is still for vanilla 2.6.20.7

Is it possible to specify ranges as allowing everyone?  Is it possible to 
allow multiple users acess to the same port?  Can ports be allowed by 
group?

I really like the idea of this patch.  It has the potential to solve a lot 
of my current administrative headachs.

	Gerhard


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
