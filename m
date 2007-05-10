Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbXEJUvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbXEJUvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXEJUvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:51:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52856
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbXEJUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:51:44 -0400
Date: Thu, 10 May 2007 13:51:47 -0700 (PDT)
Message-Id: <20070510.135147.55726615.davem@davemloft.net>
To: cw@f00f.org
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, sam@ravnborg.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070510203417.GA23019@tuatara.stupidest.org>
References: <20070510203417.GA23019@tuatara.stupidest.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wedgwood <cw@f00f.org>
Date: Thu, 10 May 2007 13:34:18 -0700

> MODPOST seems to be spewing bogus warnings.  It's not clear how best
> to fix it so perhaps we should silence it for now?

Most of them are legitimate, the only one that needs sorting
is the mm/slab.c case and people are working on that.

The rest are useful and I've been working to fix things up
on sparc64 and the networking, and in fact I'm very happy
about these notifications.

Please don't apply a sledgehammer to this issue, thanks.
