Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXCHTU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXCHTU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXCHTU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:20:58 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36231 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbXCHTUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:20:55 -0500
Date: Thu, 8 Mar 2007 11:18:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: the usage of DEBUG_DRIVER seems ambiguous
Message-Id: <20070308111858.9352f51d.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0703071941200.14336@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703071941200.14336@CPE00045a9c397f-CM001225dbafb6>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 19:44:41 -0500 (EST) Robert P. J. Day wrote:

> 
>   the usage of the DEBUG_DRIVER preprocessor variable is a big
> confusing:
> 
> $ $ grep -rw DEBUG_DRIVER *
> drivers/net/sunlance.c:#undef DEBUG_DRIVER
> drivers/net/a2065.c:#ifdef DEBUG_DRIVER
> drivers/net/a2065.c:#ifdef DEBUG_DRIVER
> drivers/net/7990.c:#ifdef DEBUG_DRIVER
> drivers/net/7990.c:#ifdef DEBUG_DRIVER
> drivers/base/Kconfig:config DEBUG_DRIVER
> ...
> 
>   it's clearly a configuration variable, but it's also being used by
> itself in a few drivers/net/ source files.  is that deliberate?

The ones in drivers/net/ are just local driver debug controls.
They happen to have the same name as a (likely newer) kconfig symbol.

Is there a real problem that needs to be fixed?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
