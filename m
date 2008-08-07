Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYHGSOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYHGSOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYHGSOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:14:15 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59341 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYHGSOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:14:15 -0400
Message-ID: <17163.166.70.238.44.1218131573.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <489B31FE.5050302@s5r6.in-berlin.de>
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>  
        <489B199B.40305@s5r6.in-berlin.de>      
    <489B1BDC.1010504@s5r6.in-berlin.de>   
    <1923.69.2.248.210.1218124570.squirrel@webmail.wolfmountaingroup.com>  
     <489B26F0.3030603@s5r6.in-berlin.de>
    <1905.69.2.248.210.1218126817.squirrel@webmail.wolfmountaingroup.com>
    <489B2EAE.8040901@s5r6.in-berlin.de>
    <489B31FE.5050302@s5r6.in-berlin.de>
Date: Thu, 7 Aug 2008 11:52:53 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wrote:
>> jmerkey@wolfmountaingroup.com wrote:
>>> check mdb-main.c -- I disable preemption before rspin_lock is
>>> attempted.
> ...
>> Then it is recommendable that you document the call context requirements
>> at the functions.
>
> An alternative would of course be to establish the non-preemptible
> context from inside the lock accessors, either redundantly to what the
> call site is doing, or instead of doing it at the call site if that can
> be arranged.
> --
> Stefan Richter
> -=====-==--- =--- --===
> http://arcgraph.de/sr/
>

It needs to get turned off right away, well before we get to the locks.

Keff


