Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYJVFI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYJVFI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYJVFIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:08:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50328
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750946AbYJVFIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:08:17 -0400
Date: Tue, 21 Oct 2008 22:07:54 -0700 (PDT)
Message-Id: <20081021.220754.06835391.davem@davemloft.net>
To: greg@kroah.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for October 21 (printk format warnings)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081022050142.GA11674@kroah.com>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au>
	<20081021215725.b9c2b941.randy.dunlap@oracle.com>
	<20081022050142.GA11674@kroah.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Tue, 21 Oct 2008 22:01:42 -0700

> What's the expected modifier for "size_t" to work on all arches?

Put "%Z" in front of the output specifier you want to use,
for example %Zd for decimal and %Zx for hex.

> Same goes for the result of "size_of()", what should we use there?  Or
> are we just required to always cast things?

Sizeof should use the same as above.
