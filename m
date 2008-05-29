Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYE2Qbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYE2Qbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYE2Qbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:31:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52573 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbYE2Qbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:31:31 -0400
Date: Thu, 29 May 2008 09:44:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       dmitry.torokhov@gmail.com
Subject: Re: linux-next: Tree for May 29
Message-Id: <20080529094454.3605aa5c.randy.dunlap@oracle.com>
In-Reply-To: <20080529182556.2994310a.sfr@canb.auug.org.au>
References: <20080529182556.2994310a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Thu, 29 May 2008 18:25:56 +1000 Stephen Rothwell wrote:

> Merging input/next

Most randconfig builds end with i8042 build errors (on i386 or x86_64)
when CONFIG_PNP=n:


linux-next-20080529/drivers/input/serio/i8042-x86ia64io.h:590: error: 'i8042_nopnp' undeclared (first use in this function)
linux-next-20080529/drivers/input/serio/i8042-x86ia64io.h:590: error: (Each undeclared identifier is reported only once
linux-next-20080529/drivers/input/serio/i8042-x86ia64io.h:590: error: for each function it appears in.)
make[3]: *** [drivers/input/serio/i8042.o] Error 1

---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
