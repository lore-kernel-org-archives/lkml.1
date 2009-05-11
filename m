Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbZEKD0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbZEKD0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZEKD0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:26:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49350 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZEKD0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:26:06 -0400
Message-Id: <200905110326.n4B3Q2Z1095200@www262.sakura.ne.jp>
Subject: Re: Q: semaphore and kmalloc(GFP_KERNEL)?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 11 May 2009 12:26:02 +0900
References: <20090511115410.B0EA.A69D9226@jp.fujitsu.com> <200905110319.n4B3J9hc092830@www262.sakura.ne.jp> <20090511122046.B0ED.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090511122046.B0ED.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 11052009 #1952945, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> > Then, should I move kmalloc(GFP_KERNEL) to outside the lock whenever possible?
> 
> Yes. almost driver does it.
> this is generic issue of nested locking.

I see. I'll try to rewrite.
Thank you.
