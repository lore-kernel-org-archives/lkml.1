Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbXGILig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbXGILig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbXGILi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:38:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54063 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbXGILi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:38:28 -0400
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>
In-Reply-To: <6D63B142.2080404@linux.vnet.ibm.com>
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>
	 <6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>
	 <467B2F4F.2030101@openvz.org>
	 <6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>
	 <661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com>
	 <6599ad830706250019h117ff575h156cf112f5778e43@mail.gmail.com>
	 <6D63B142.2080404@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 13:38:18 +0200
Message-Id: <1183981098.1913.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2028-02-27 at 02:39 -0500, Balbir Singh wrote:

> I am not a CLUI expert, but rounding off bytes will something that
> the administrators will probably complain about. Since we manage
> the controller memory in pages, it might be the easiest unit to use.
> The output is totally different matter.
> 
> Having said that, I am not opposed to your suggestion, I'll see if
> I can find good CLUI guidelines.

Pages are generally considered a bad unit for user-space exposed
parameters because a page can have a wide spectrum of sizes on some
machines.

The typical unit used in its stead is KiB. Although I could imagine MiB
being more useful in this case :-)

Perhaps a new proc parser that takes postfix [KMG] units would be
handy..

