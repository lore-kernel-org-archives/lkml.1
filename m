Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbYFTVrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbYFTVrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYFTVri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:47:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40131
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753776AbYFTVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:47:37 -0400
Date: Fri, 20 Jun 2008 14:47:36 -0700 (PDT)
Message-Id: <20080620.144736.224107106.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080620.144424.168785883.davem@davemloft.net>
References: <20080620.142034.30884440.davem@davemloft.net>
	<Pine.LNX.4.64.0806201723120.14221@engineering.redhat.com>
	<20080620.144424.168785883.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 20 Jun 2008 14:44:24 -0700 (PDT)

> I agree on both counts.  Although I'm curious what the average stack
> frame sizes look like on x86_64 and i386, and also how this area
> appears on powerpc.

I also one to mention in passing that another thing we can do to
help deep call stack sizes is to make call chains more tail-call
friendly when possible.
