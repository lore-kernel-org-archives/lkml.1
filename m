Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbYEIAMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbYEIAMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYEIAMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:12:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46260 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbYEIAMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:12:12 -0400
Date: Fri, 9 May 2008 09:15:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mark res_counter_charge(_locked) with __must_check
Message-Id: <20080509091509.439fda80.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4822CAA5.9020401@openvz.org>
References: <4822C268.7060501@openvz.org>
	<20080508184038.f3f2af47.kamezawa.hiroyu@jp.fujitsu.com>
	<4822CAA5.9020401@openvz.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 13:40:53 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

> > BTW, res_counter_charge_locked() should be extern function ?
> 
> What do you mean? It is extern as well as the res_counter_charge
> and uncharge ones are, but functions may have forward declarations
> w/o extern keyword AFAIK ;)
>
Ah, 
Is  res_counter_charge_locked() is called from files other than res_counter.c ?
Does we need declaration in header file ?

Thanks,
-Kame

