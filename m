Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbZBWXjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbZBWXjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZBWXjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:39:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53726
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbZBWXjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:39:19 -0500
Date: Mon, 23 Feb 2009 15:38:59 -0800 (PST)
Message-Id: <20090223.153859.265316948.davem@davemloft.net>
To: eugeneteo@kernel.sg
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mpatocka@redhat.com
Subject: Re: net: amend the fix for SO_BSDCOMPAT gsopt infoleak
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090223164112.GA29425@kernel.sg>
References: <20090223164112.GA29425@kernel.sg>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eugene Teo <eugeneteo@kernel.sg>
Date: Tue, 24 Feb 2009 00:41:12 +0800

> The fix for CVE-2009-0676 (upstream commit df0bca04) is incomplete. Note
> that the same problem of leaking kernel memory will reappear if someone
> on some architecture uses struct timeval with some internal padding (for
> example tv_sec 64-bit and tv_usec 32-bit) --- then, you are going to
> leak the padded bytes to userspace.
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>

Applied and queued up for -stable, thanks Eugene.
