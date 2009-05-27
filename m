Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbZE0DrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbZE0DrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZE0DrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:47:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48620
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbZE0DrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:47:11 -0400
Date: Tue, 26 May 2009 20:47:10 -0700 (PDT)
Message-Id: <20090526.204710.124271694.davem@davemloft.net>
To: menage@google.com
Cc: lizf@cn.fujitsu.com, akpm@linux-foundation.org, tgraf@suug.ch,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] cls_cgroup: read classid atomically in classifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090526195840.8464.36548.stgit@menage.mtv.corp.google.com>
References: <20090526195840.8464.36548.stgit@menage.mtv.corp.google.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Menage <menage@google.com>
Date: Tue, 26 May 2009 12:59:11 -0700

> cls_cgroup: read classid atomically in classifier
> 
> Avoid reading the unsynchronized value cs->classid multiple times,
> since it could change concurrently from non-zero to zero; this would
> result in the classifier returning a positive result with a bogus
> (zero) classid.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Patch applied, thanks!
