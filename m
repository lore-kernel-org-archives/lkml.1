Return-Path: <linux-kernel-owner+w=401wt.eu-S1764749AbXJZXwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764749AbXJZXwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXJZXwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:52:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34386
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbXJZXwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:52:33 -0400
Date: Fri, 26 Oct 2007 16:52:35 -0700 (PDT)
Message-Id: <20071026.165235.124016148.davem@davemloft.net>
To: rick.jones2@hp.com
Cc: ebiederm@xmission.com, bunk@kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] always export sysctl_{r,w}mem_max
From: David Miller <davem@davemloft.net>
In-Reply-To: <47227C5C.1070507@hp.com>
References: <472278E3.4000909@hp.com>
	<20071026.163958.171785530.davem@davemloft.net>
	<47227C5C.1070507@hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rick Jones <rick.jones2@hp.com>
Date: Fri, 26 Oct 2007 16:46:36 -0700

> David Miller wrote:
> > If DLM really wants minimum, it can use SO_SNDBUFFORCE and
> > SO_RCVBUFFORCE socket options and use whatever limits it
> > likes.
> > 
> > But even this is questionable.
> 
> Drift...
> 
> Is that something netperf should be using though?  Right now it uses the regular 
> SO_[SND|RCV]BUF calls and is at the mercy of sysctls.  I wonder if it would be 
> better to have it use their FORCE versions to make life easier on the 
> benchmarker - such as myself - who has an unfortunate habit of forgetting to 
> update sysctl.conf :)

The force calls are for root only.

And I want to remind you that explicitly setting socket
buffer sizes hurts performance with TCP.  I know you know
this but it bears restating for the benefit of others.
