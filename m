Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZHDCcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZHDCcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 22:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZHDCcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 22:32:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39887
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169AbZHDCcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 22:32:24 -0400
Date: Mon, 03 Aug 2009 19:32:33 -0700 (PDT)
Message-Id: <20090803.193233.170901476.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]atl1c:Do not call cancel_work_sync from the work itself
From: David Miller <davem@davemloft.net>
In-Reply-To: <12493523461127-git-send-email-jie.yang@atheros.com>
References: <12493523461127-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Tue, 4 Aug 2009 10:19:06 +0800

> Do not call cancel_work_sync from the work itself, for it my cause 
> recursive locking.

Sorry, this won't work.

Your patches, all of them, are corrupted by your email client.  It
turns tab characters into spaces as well as making other textual
modifications to the patch, such that it will not apply.

Please fix this up and resubmit all of your patches when the problem
is corrected.

If you have to, email the patches to yourself and try to apply them
just to make sure.
