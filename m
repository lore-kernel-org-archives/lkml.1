Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbYJMQcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbYJMQcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYJMQcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:32:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14491 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbYJMQcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:32:06 -0400
Message-ID: <48F377F4.7070502@oracle.com>
Date: Mon, 13 Oct 2008 09:31:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Neshama Parhoti <pneshama@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: section mismatch with a platform driver
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>	 <20081013085111.GB29938@cs181140183.pp.htv.fi>	 <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>	 <20081013090133.a58116a2.randy.dunlap@oracle.com> <912ec82a0810130929h42574fav985e922ad019b8f5@mail.gmail.com>
In-Reply-To: <912ec82a0810130929h42574fav985e922ad019b8f5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neshama Parhoti wrote:
> On Mon, Oct 13, 2008 at 6:01 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> A probe function can be called at any time -- i.e., after system init
>> has completed, so discarding the __init function my_probe_func() is BAD,
>> dangerous, BUGgy.
> 
> Thanks for the explanation!
> 
> Does that mean that all drivers with __init in their probe functions are bogus ?

It depends.  If your platform doesn't support hotplug, then it's possible
that the probe function is only called during system init, so it would be OK.

And in general, if a kernel is built without hotplug support, then the
__init probe functions are probably safe.  But I'm not sure about it.

-- 
~Randy
