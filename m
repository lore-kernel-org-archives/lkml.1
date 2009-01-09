Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZAIGrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZAIGrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZAIGrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:47:03 -0500
Received: from 1wt.eu ([62.212.114.60]:1288 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZAIGrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:47:02 -0500
Date: Fri, 9 Jan 2009 07:46:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
Message-ID: <20090109064658.GG5038@1wt.eu>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 07:23:43PM -0700, jmerkey@wolfmountaingroup.com wrote:
> iptables is just too cumbersome and memory comsumptive to work well and
> has a shitty app inteface so I wrote one with a kernel level database and
> combined it with postfix.    This firewall actually drops packets on the
> floor by port, or in their entirety by IP address to deal with these
> jerks.
> 
> The code is a kernel module that will build an RBL database to disk and it
> will cache up to 500,000 IP addresses efficiently on a 1GB home personal
> computer.  The more memory you have, the more IP addresses you can cache. 
> It is configurable and possible to hold millions of them if you have 4GB
> of memory in the server.

why didn't you use ipset for that ? It's designed exactly for this usage
and is a lot easier to use than plain iptables for dynamic filtering.

Willy

