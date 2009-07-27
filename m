Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZG0CVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZG0CVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 22:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZG0CVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 22:21:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59681
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925AbZG0CVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 22:21:03 -0400
Date: Sun, 26 Jul 2009 19:21:09 -0700 (PDT)
Message-Id: <20090726.192109.14263864.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: dfeng@redhat.com, bridge@lists.linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/bridge: use kobject_put to release kobject in
 br_add_if error path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090724083607.6b91282d@nehalam>
References: <1248426392-30777-1-git-send-email-dfeng@redhat.com>
	<20090724083607.6b91282d@nehalam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Fri, 24 Jul 2009 08:36:07 -0700

> On Fri, 24 Jul 2009 17:06:32 +0800
> Xiaotian Feng <dfeng@redhat.com> wrote:
> 
>> kobject_init_and_add will alloc memory for kobj->name, so in br_add_if
>> error path, simply use kobject_del will not free memory for kobj->name.
>> Fix by using kobject_put instead, kobject_put will internally calls
>> kobject_del and frees memory for kobj->name.
>> 
>> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
...
> 
> I assume you tested this by doing something like adding two interfaces
> with the same MAC address to a bridge.
> 
> Acked-by: Stephen Hemminger <shemminger@vyatta.com>

Applied, thanks!
