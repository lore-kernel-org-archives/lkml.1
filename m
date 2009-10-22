Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbZJVV4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbZJVV4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZJVV4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:56:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49525
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbZJVV4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:56:23 -0400
Date: Thu, 22 Oct 2009 14:56:45 -0700 (PDT)
Message-Id: <20091022.145645.249762938.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: sparc64 cmpxchg is not a full memory barrier anymore ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091022183242.GA19307@Krystal>
References: <20091022183242.GA19307@Krystal>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 22 Oct 2009 14:32:42 -0400

> The same applies to the other atomic instructions we find in this list.
> How is the correct ordering of loads wrt to cmxchg (and other atomic
> ops) still ensured by this modification?

All actual sparc64 chips implement more strict ordering than
the V9 specification permits.  The memory barriers were just
nops and actually not doing anything more than the chip
already does for us.
