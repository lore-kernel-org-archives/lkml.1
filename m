Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbXLNFpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbXLNFpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 00:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXLNFpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 00:45:32 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59056 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXLNFpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 00:45:32 -0500
Date: Thu, 13 Dec 2007 21:45:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.24-rc5-mm1] Why CONFIG_BLK_DEV_RAM=m makes
 \"#ifdef CONFIG_BLK_DEV_RAM\" false?
Message-Id: <20071213214509.f27c2717.randy.dunlap@oracle.com>
In-Reply-To: <200712140504.lBE54Jpa044093@www262.sakura.ne.jp>
References: <200712140504.lBE54Jpa044093@www262.sakura.ne.jp>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 14:04:19 +0900 Tetsuo Handa wrote:

> Hello.
> 
> I found that
> 
>  CONFIG_BLK_DEV_RAM=m
> 
> in my .config makes
> 
>  #ifdef CONFIG_BLK_DEV_RAM
> 
> false.
> 
> I guess something is wrong with .config parsing.

Look at include/linux/autoconf.h.  You should see a line like:

#define CONFIG_BLK_DEV_RAM_MODULE 1

if CONFIG_BLK_DEV_RAM=m

or like:

#define CONFIG_BLK_DEV_RAM 1

if CONFIG_BLK_DEV_RAM=y.


I don't think that this is a change from the recent past.

---
~Randy
