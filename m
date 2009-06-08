Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbZFHFTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbZFHFTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 01:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZFHFSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 01:18:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZFHFSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 01:18:50 -0400
Date: Sun, 7 Jun 2009 22:18:52 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: netdev@vger.kernel.org, mcarlson@broadcom.com
Subject: Re: tg3 stops working when NFS is involved
In-Reply-To: <alpine.DEB.2.01.0906072115420.6439@bogon>
Message-ID: <alpine.DEB.2.01.0906072215000.6439@bogon>
References: <alpine.DEB.2.01.0906072115420.6439@bogon>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/LOc269cJBvianT4foJVxHVvzSFLGt2b0i5zU
 uuvZXs7lO6YWenwY13Clv/2S7Hgm0Qr52adzZK8LbOnZ7SZRrw
 tNrMyk3E8EJuwbo2FEUUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Jun 2009, Christian Kujau wrote:
> anything else - so, I figure it's not a client problem. And I'm not sure 
> if it's NFS problem either, because restarting the NFS server doesn't do 
> anything, I really have to rmmod/modprobe the tg3 module. OTOH, I cannot 
> reproduce this without NFS: running e.g. iperf (TCP, UDP) did not trigger 
> it.

Just tested with Samba - after a few megabytes of transmitted data, tg3 stops 
working, with no messages printed in the kernel log :-\

I don't know why iperf does not trigger it though....

Christian.
-- 
BOFH excuse #271:

The kernel license has expired
