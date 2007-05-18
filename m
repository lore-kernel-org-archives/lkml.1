Return-Path: <linux-kernel-owner+w=401wt.eu-S1763129AbXERVQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763129AbXERVQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbXERVPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:15:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25597 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbXERVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:15:53 -0400
Date: Fri, 18 May 2007 14:17:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: building i386 requires s390: "driver/crypto/Kconfig" sourcing
 s390 arch
Message-Id: <20070518141735.aae3921a.randy.dunlap@oracle.com>
In-Reply-To: <464DFF5F.5010905@tlinx.org>
References: <464DFF5F.5010905@tlinx.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 12:32:47 -0700 Linda Walsh wrote:

> Seems there is an include of s390 based config in file
> drivers/crypto/Kconfig: source "arch/s390/crypto/Kconfig"
> 
> The line doesn't seem to be need for an i386 build (haven't
> tried x86_64 though).
> 
> I take it that this was a braino?

Does it cause a problem?  If yes, what problem?

It looks like someone thought that all Hardware crypto devices
should be listed under the same menu heading.  Makes some sense.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
