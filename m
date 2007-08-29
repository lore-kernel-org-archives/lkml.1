Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbXH2Eyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbXH2Eyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXH2Eys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:54:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43463
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbXH2Eys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:54:48 -0400
Date: Tue, 28 Aug 2007 21:54:45 -0700 (PDT)
Message-Id: <20070828.215445.38711684.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, balbir@in.ibm.com,
       serue@us.ibm.com, ebiederm@xmission.com, containers@lists.osdl.org
Subject: Re: [PATCH] Send quota messages via netlink
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070828211335.37fce4c9.akpm@linux-foundation.org>
References: <20070828141318.GC5869@duck.suse.cz>
	<20070828211335.37fce4c9.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 28 Aug 2007 21:13:35 -0700

> This is it.  Normally netlink payloads are represented as a struct.  How
> come this one is built-by-hand?

He is using attributes, which is perfect and arbitrarily
extensible with zero backwards compatability concerns.

If he wants to provide a new attribute, he just adds it
without any issues.

When new attributes are added, older apps simply ignore the attributes
they don't understand.
