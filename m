Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXCHTEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXCHTEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbXCHTEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:04:34 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58828 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054AbXCHTEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:04:33 -0500
Date: Thu, 8 Mar 2007 11:01:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Nitschinger <michael@nitschinger.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/null implementation question
Message-Id: <20070308110129.dc80b640.randy.dunlap@oracle.com>
In-Reply-To: <20070308190139.dd37b70e.michael@nitschinger.at>
References: <20070308190139.dd37b70e.michael@nitschinger.at>
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

On Thu, 8 Mar 2007 19:01:39 +0100 Michael Nitschinger wrote:

> Hello,
> 
> I asked myself how /dev/null is implemented in C, but i didn't find anything in the documentation or generally on the internet. It would be great if someone could tell me where i can find the source for this device or how it is implemented, because it's really hard for me to crawl through the whole sourcetree.
> 
> thanks in advance, kind regards
> Michael Nitschinger
> 
> (p.s.: it would be great if you can Cc me in your answers because i am not subscribed to the mailinglist! thanks)

See linux/drivers/char/mem.c, look for null_fops.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
