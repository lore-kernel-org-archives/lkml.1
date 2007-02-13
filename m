Return-Path: <linux-kernel-owner+w=401wt.eu-S1750777AbXBMQPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750777AbXBMQPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXBMQPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:15:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:51875 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbXBMQPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:15:14 -0500
Date: Tue, 13 Feb 2007 08:10:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <ak@suse.de>, Christoph Hellwig <hch@infradead.org>,
       Segher Boessenkool <segher@kernel.crashing.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [1/29] i386: avoid gcc extension
Message-Id: <20070213081023.1fc951ff.randy.dunlap@oracle.com>
In-Reply-To: <200702131611.15172.arnd@arndb.de>
References: <20070212551.664370000@suse.de>
	<200702131611.15172.arnd@arndb.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 16:11:14 +0100 Arnd Bergmann wrote:

> On Monday 12 February 2007 17:51, Andi Kleen wrote:
> > setcc() in math-emu is written as a gcc extension statement expression
> > macro that returns a value.  However, it's not used that way and it's not
> > needed like that, so just make it a do-while non-extension macro so that we
> > don't use an extension when it's not needed.
> > 
> 
> The patch looks good but it doesn't match the description any more, since
> you now use a function...

Hi Arnd,
Someone else had that same comment, so I sent a corrected patch
(description change only) to that mail.

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
