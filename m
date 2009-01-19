Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbZASKTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbZASKTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbZASKTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:19:37 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36616 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbZASKTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:19:36 -0500
Message-ID: <497453B6.8090403@s5r6.in-berlin.de>
Date: Mon, 19 Jan 2009 11:19:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Nick Craig-Wood <nick@craig-wood.com>
CC: David Wagner <daw@cs.berkeley.edu>, linux-kernel@vger.kernel.org
Subject: Re: Checking module parameters
References: <bVsVO-15X-19@gated-at.bofh.it> <20090119093814.BC18014CA88@irishsea.home.craig-wood.com>
In-Reply-To: <20090119093814.BC18014CA88@irishsea.home.craig-wood.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Craig-Wood wrote:
> David Wagner <daw@cs.berkeley.edu> wrote:
>>  Is there a way to tell what options have been applied to a currently
>>  loaded kernel module?
>> 
>>  I'm trying to force libata to use 1.5Gbps rather than 3Gbps,
...
> I had to do this recently (under debian I ended up putting
> "libata force=1.5Gbps" into /etc/modules)
> 
> You can check it is working by looking for something like this in the log
> 
> [    2.345058] ata1: FORCE: PHY spd limit set to 1.5Gbps
> [    2.345058] ata1: SATA max UDMA/133 abar m2048@0xfb106000 port 0xfb106100 irq 218

There is also /sys/module/*/parameters/* which can be read and in some
cases even be written.
-- 
Stefan Richter
-=====-==--= ---= =--==
http://arcgraph.de/sr/
