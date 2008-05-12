Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbYELHSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbYELHSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbYELHSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:18:06 -0400
Received: from sacred.ru ([62.205.161.221]:37375 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbYELHSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:18:05 -0400
Message-ID: <4827ED00.9040201@openvz.org>
Date: Mon, 12 May 2008 11:08:48 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mark res_counter_charge(_locked) with __must_check
References: <4822C268.7060501@openvz.org>	<20080508184038.f3f2af47.kamezawa.hiroyu@jp.fujitsu.com>	<4822CAA5.9020401@openvz.org> <20080509091509.439fda80.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080509091509.439fda80.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 12 May 2008 11:11:21 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 08 May 2008 13:40:53 +0400
> Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>>> BTW, res_counter_charge_locked() should be extern function ?
>> What do you mean? It is extern as well as the res_counter_charge
>> and uncharge ones are, but functions may have forward declarations
>> w/o extern keyword AFAIK ;)
>>
> Ah, 
> Is  res_counter_charge_locked() is called from files other than res_counter.c ?

I checked - everything was OK.

> Does we need declaration in header file ?

But this patch _is_ for declaration in header :)

> Thanks,
> -Kame
> 
> 

