Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZIPWcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZIPWcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZIPWcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:32:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49780
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbZIPWcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:05 -0400
Date: Wed, 16 Sep 2009 15:32:21 -0700 (PDT)
Message-Id: <20090916.153221.257687176.davem@davemloft.net>
To: tabbott@ksplice.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       geofft@ksplice.com
Subject: Re: [PATCH v2] sparc: Clean up linker script using new linker
 script macros.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0909161332190.2942@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0909161322260.2942@dr-wily.mit.edu>
	<20090916.103019.253722423.davem@davemloft.net>
	<alpine.DEB.1.10.0909161332190.2942@dr-wily.mit.edu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@ksplice.com>
Date: Wed, 16 Sep 2009 14:03:48 -0400 (EDT)

> On Wed, 16 Sep 2009, David Miller wrote:
> 
>> It's hard for me to ACK this because it's not a straight nop
>> transformation, which we could at least presume would function
>> properly if the macros were implemented correctly.
> 
> Would it help if I were to split the patch into first rearranging the code 
> to look like the macros and then applying the macros, so that you can see 
> more easily exactly what is changing?

No, it wouldn't :-)  The issue is that I can't just say from
reading the patch that it will absolutely work.

But I'm willing to take the risk and we can revert if testing
shows it breaks things, so:

Acked-by: David S. Miller <davem@davemloft.net>
