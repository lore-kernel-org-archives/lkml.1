Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbXKFEMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbXKFEMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 23:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXKFEMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 23:12:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48744 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbXKFEMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:12:19 -0500
Date: Mon, 5 Nov 2007 20:11:26 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, crispin@crispincowan.com
Subject: Re: Problem with accessing namespace_sem from LSM.
Message-ID: <20071105201126.6b58bbd1@laptopd505.fenrus.org>
In-Reply-To: <200711060400.lA640fuE078356@www262.sakura.ne.jp>
References: <200711060400.lA640fuE078356@www262.sakura.ne.jp>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Nov 2007 13:00:41 +0900
Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Hello.
> 
> I found that accessing namespace_sem from security_inode_create()
> causes lockdep warning when compiled with CONFIG_PROVE_LOCKING=y .
> 
> 

sounds like you have an AB-BA deadlock...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
