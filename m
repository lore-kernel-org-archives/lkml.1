Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbYEHJgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbYEHJgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYEHJfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:35:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33883 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYEHJfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:35:52 -0400
Date: Thu, 8 May 2008 18:40:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mark res_counter_charge(_locked) with __must_check
Message-Id: <20080508184038.f3f2af47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4822C268.7060501@openvz.org>
References: <4822C268.7060501@openvz.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 13:05:44 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

> Ignoring theirs return value may result in counter underflow
> in the future - when the value charged will be uncharged (or in
> "leaks" - when the value is not uncharged).
> 
> This also prevents from using charging routines to decrement the
> counter value (i.e. uncharge it) ;)
> 
> (Current code works OK with res_counter, however :) )
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
nice check :)

BTW, res_counter_charge_locked() should be extern function ?

Thanks,
-Kame

