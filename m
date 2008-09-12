Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYILWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYILWkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYILWkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:40:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47236
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbYILWkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:40:21 -0400
Date: Fri, 12 Sep 2008 15:40:15 -0700 (PDT)
Message-Id: <20080912.154015.93377289.davem@davemloft.net>
To: roland@redhat.com
Cc: rmk+lkml@arm.linux.org.uk, linux-arch@vger.kernel.org,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HAVE_ARCH_TRACEHOOK and you
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080912223926.5EF0715420D@magilla.localdomain>
References: <20080912223156.51D4815420D@magilla.localdomain>
	<20080912.153703.21849753.davem@davemloft.net>
	<20080912223926.5EF0715420D@magilla.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Fri, 12 Sep 2008 15:39:26 -0700 (PDT)

> > It was allocating too much memory, which is harmless.
> 
> Didn't it also write NT_PRFPREG notes of the wrong size?

Yep, but gdb was "generous in what it received" and happily
read the contents.
