Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYA3FOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYA3FOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYA3FO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:14:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46114
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbYA3FO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:14:27 -0500
Date: Tue, 29 Jan 2008 21:14:46 -0800 (PST)
Message-Id: <20080129.211446.254604070.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH retry] bluetooth : add conn add/del workqueues to avoid
 connection fail
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080130022354.GA3132@darkstar.te-china.tietoenator.com>
References: <20080130022354.GA3132@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Wed, 30 Jan 2008 10:23:54 +0800

> 
> The bluetooth hci_conn sysfs add/del executed in the default workqueue.
> If the del_conn is executed after the new add_conn with same target,
> add_conn will failed with warning of "same kobject name".
> 
> Here add btaddconn & btdelconn workqueues,
> flush the btdelconn workqueue in the add_conn function to avoid the issue.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

This looks good, applied, thanks Dave.

I've queued this up for 2.6.25 merging, if you want me to
schedule it for -stable, just let me know.

Thanks again.
