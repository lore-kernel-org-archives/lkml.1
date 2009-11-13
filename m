Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZKMI7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZKMI7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZKMI7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:59:45 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:51661 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbZKMI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:59:44 -0500
Message-ID: <4AFD1FF1.7080906@s5r6.in-berlin.de>
Date: Fri, 13 Nov 2009 09:59:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: sclark46@earthlink.net,
       William Allen Simpson <william.allen.simpson@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Documentation: rw_lock lessons learned
References: <4AF9C540.5090403@gmail.com>	<20091110180646.2e5859a8@nehalam>	<4AFAEF78.4080807@gmail.com>	<20091111093724.4f40a48d@nehalam>	<4AFBEC44.9030409@gmail.com>	<4AFC5E3F.7070609@earthlink.net> <20091112150029.1a26c641@nehalam>
In-Reply-To: <20091112150029.1a26c641@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Thu, 12 Nov 2009 14:13:03 -0500
> Stephen Clark <sclark46@earthlink.net> wrote:
>> How up to date is this doc?
>> 
>> http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/index.html
>> 
> 
> Out of date.
> 1. Missing mutex's which have largely replaced semaphores.
> 
> 2. Missing change to lock initialization in later kernels.
> 
> 3. Missing description of lock dependency checker which should be in same guide.

4. The section on atomic reference counting should refer to <linux/kref.h>.
-- 
Stefan Richter
-=====-==--= =-== -==-=
http://arcgraph.de/sr/
