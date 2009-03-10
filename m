Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbZCJURZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbZCJURZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZCJURQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:17:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42636
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbZCJURP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:17:15 -0400
Date: Tue, 10 Mar 2009 13:17:00 -0700 (PDT)
Message-Id: <20090310.131700.40129006.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: geert@linux-m68k.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
From: David Miller <davem@davemloft.net>
In-Reply-To: <49B6C8BF.8010105@oracle.com>
References: <49B6B821.5050302@oracle.com>
	<10f740e80903101256v2cfe08a8g410c297e019d8693@mail.gmail.com>
	<49B6C8BF.8010105@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 10 Mar 2009 13:08:31 -0700

> I'll have to let David or Herbert answer that.  From my quick look
> at the code, I don't see much use for nlattr.c when CONFIG_NET
> is not enabled.

We want to use the netlink attribute parsers even in non-networking
code, that's what he's trying to do here.
