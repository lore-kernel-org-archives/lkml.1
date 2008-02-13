Return-Path: <linux-kernel-owner+w=401wt.eu-S1765662AbYBMB0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765662AbYBMB0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764619AbYBMB01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:26:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36899
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762558AbYBMB0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:26:25 -0500
Date: Tue, 12 Feb 2008 17:26:56 -0800 (PST)
Message-Id: <20080212.172656.118569021.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: paulmck@us.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] hlist_for_each_entry_continue simplification
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213005122.879352336@vyatta.com>
References: <20080213005042.150212716@vyatta.com>
	<20080213005122.879352336@vyatta.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 12 Feb 2008 16:50:46 -0800

> All the users of hlist_for_each_entry_continue had to intialize pos
> before use; change API so pos is a pure temporary variable which matches
> the usage of other xxxx_for_each_entry routines.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

linux/list.h changes need to be reviewed on linux-kernel and
merged into Linus's tree via some means other than the
networking tree.

I just got chewed out for a similar issue wrt. the rcupdate.h
changes of yesterday and thus have to remove them from my
tree.
