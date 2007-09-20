Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXITQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXITQgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbXITQgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:36:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:57292 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbXITQgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:36:06 -0400
Date: Thu, 20 Sep 2007 09:35:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Ph. Marek" <philipp@marek.priv.at>
Cc: "Jeff Dike" <jdike@addtoit.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: UML dead with current -git?
Message-Id: <20070920093522.35264e5c.randy.dunlap@oracle.com>
In-Reply-To: <41830.193.171.152.61.1190266958.squirrel@webmail.marek.priv.at>
References: <200709181714.34035@x5>
	<200709191443.24158@x5>
	<20070919085032.dd5c1732.randy.dunlap@oracle.com>
	<200709191817.51921@x5>
	<20070919104703.4c9d432f.randy.dunlap@oracle.com>
	<41830.193.171.152.61.1190266958.squirrel@webmail.marek.priv.at>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 07:42:38 +0200 (CEST) Ph. Marek wrote:

> Hello Randy!
> 
> > This doesn't work when there is no include/asm symlink.
> Why? I specifically test for that, and tried it on my machine.
> What's the bug?
> ASMARCH should come out empty, and the ?= and $(or) should take care of
> the rest ...

Sorry, I can't reproduce it now.
The variable was coming out empty though.  I saw path strings like
  linux-2.6.23-rc6/arch//Makefile

Hopefully Sam can fix it all up.  :)

> > It also didn't apply cleanly due to tab(s) being converted
> > to spaces (but of course I fixed that part).
> Yes, sorry. I'll try to attach inline next time.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
