Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYA3KX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYA3KX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYA3KVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:21:05 -0500
Received: from senator.holtmann.net ([87.106.208.187]:50450 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696AbYA3KVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:21:01 -0500
Subject: Re: [PATCH retry] bluetooth : add conn add/del workqueues to avoid
	connection fail
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <20080129.211446.254604070.davem@davemloft.net>
References: <20080130022354.GA3132@darkstar.te-china.tietoenator.com>
	 <20080129.211446.254604070.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 11:21:02 +0100
Message-Id: <1201688462.6218.47.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > The bluetooth hci_conn sysfs add/del executed in the default workqueue.
> > If the del_conn is executed after the new add_conn with same target,
> > add_conn will failed with warning of "same kobject name".
> > 
> > Here add btaddconn & btdelconn workqueues,
> > flush the btdelconn workqueue in the add_conn function to avoid the issue.
> > 
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> This looks good, applied, thanks Dave.
> 
> I've queued this up for 2.6.25 merging, if you want me to
> schedule it for -stable, just let me know.

don't include it. I first have to stress test it on one of my machines.
Besides that I have to do some coding style cleanups.

Regards

Marcel


