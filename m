Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYBPJ1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYBPJ1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 04:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYBPJ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 04:27:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57162
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbYBPJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 04:27:07 -0500
Date: Sat, 16 Feb 2008 01:27:41 -0800 (PST)
Message-Id: <20080216.012741.243894500.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: hidave.darkstar@gmail.com
Subject: Re: + bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc.patch
 added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802160449.m1G4nX5V009024@imap1.linux-foundation.org>
References: <200802160449.m1G4nX5V009024@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Fri, 15 Feb 2008 20:49:33 -0800

> Subject: bluetooth: fix warning in net/bluetooth/hci_sysfs.c
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> net/bluetooth/hci_sysfs.c: In function 'del_conn':
> net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assignment used as truth value
> 
> Cc: Dave Young <hidave.darkstar@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Linus barfed when this exact patch got posted a few weeks
ago, he said he considers just adding parenthesis to quiet
this warning awful and explicit NULL test should be used.
