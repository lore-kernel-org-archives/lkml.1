Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYHGReE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYHGReE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYHGRdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:33:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34811 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYHGRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:33:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489B31FE.5050302@s5r6.in-berlin.de>
Date: Thu, 07 Aug 2008 19:33:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>       <489B199B.40305@s5r6.in-berlin.de>       <489B1BDC.1010504@s5r6.in-berlin.de>    <1923.69.2.248.210.1218124570.squirrel@webmail.wolfmountaingroup.com>    <489B26F0.3030603@s5r6.in-berlin.de> <1905.69.2.248.210.1218126817.squirrel@webmail.wolfmountaingroup.com> <489B2EAE.8040901@s5r6.in-berlin.de>
In-Reply-To: <489B2EAE.8040901@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> jmerkey@wolfmountaingroup.com wrote:
>> check mdb-main.c -- I disable preemption before rspin_lock is 
>> attempted.
...
> Then it is recommendable that you document the call context requirements 
> at the functions.

An alternative would of course be to establish the non-preemptible 
context from inside the lock accessors, either redundantly to what the 
call site is doing, or instead of doing it at the call site if that can 
be arranged.
-- 
Stefan Richter
-=====-==--- =--- --===
http://arcgraph.de/sr/
