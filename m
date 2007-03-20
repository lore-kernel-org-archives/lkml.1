Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbXCTXuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbXCTXuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 19:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXCTXuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 19:50:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12508 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXCTXuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 19:50:08 -0400
Date: Tue, 20 Mar 2007 16:49:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070320164923.ebab4e53.randy.dunlap@oracle.com>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
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

On Mon, 19 Mar 2007 20:56:23 -0800 Andrew Morton wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/


I think that this:

config EEPROM_93CX6
	tristate "EEPROM 93CX6 support"
	---help---
	This is a driver for the EEPROM chipsets 93c46 and 93c66.
	The driver supports both read as well as write commands.

should not be in lib/Kconfig.  lib/ is not for drivers.
or (simpler) s/driver/library/
but I think I'd rather see it in drivers/misc/.


and the help text needs to be indented 2 more spaces...

---
~Randy
boilerplate:
*** Remember to use Documentation/SubmitChecklist when testing your code ***
