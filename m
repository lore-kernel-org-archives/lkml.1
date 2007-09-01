Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbXIAEJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbXIAEJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 00:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXIAEJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 00:09:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17832 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbXIAEJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 00:09:06 -0400
Date: Fri, 31 Aug 2007 21:06:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: johannes@sipsolutions.net, akpm <akpm@linux-foundation.org>
Subject: Re: kernel-doc: fix doc blocks and html
Message-Id: <20070831210643.d5e2b5b1.randy.dunlap@oracle.com>
In-Reply-To: <20070831205845.0a935dc5.randy.dunlap@oracle.com>
References: <20070831205845.0a935dc5.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 20:58:45 -0700 Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Cc: johannes@sipsolutions.net
> 
> Johannes Berg reports (Thanks!) that &struct names are not highlighted in
> html output format when they are inside a DOC: block.
> 
> DOC: blocks were not escaped thru xml_escape() like other kernel-doc
> comments were.  Fixed that.


Johannes is using a feature of kernel-doc that I wasn't even familiar
with, also one that no one else is using.  I'm sure that Johannes can
point us to some source code and generated output for it though.

If you want to see a little of it in source code form, 2 net drivers
use it, but then they aren't processed by kernel-doc for generated
output.  They are drivers/net/3c501.c & 3c527.c.  Look for the
"DOC:" comment blocks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
