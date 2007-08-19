Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbXHSWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbXHSWgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXHSWgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:36:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:57628 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbXHSWgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:36:35 -0400
Date: Sun, 19 Aug 2007 15:41:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Markus Rechberger <markus.rechberger@amd.com>
Subject: Re: [PATCH 4/5] Documentation/firmware/... convert #include
 "linux/..." to #include <linux/...>
Message-Id: <20070819154146.337bf347.randy.dunlap@oracle.com>
In-Reply-To: <1187562717.4200.154.camel@localhost>
References: <1187561972.4200.143.camel@localhost>
	<20070819153422.1e0b54af.randy.dunlap@oracle.com>
	<1187562717.4200.154.camel@localhost>
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

On Sun, 19 Aug 2007 15:31:57 -0700 Joe Perches wrote:

> On Sun, 2007-08-19 at 15:34 -0700, Randy Dunlap wrote:
> > > -#include "linux/firmware.h"
> > > +#include "firmware.h"
> > I believe that it should be <linux/firmware.h>.
> 
> OK.
> 
> That's not my taste though, especially if only
> included by files in the firmware_class directory.
> Less pollution/namespace collision in include/linux

It's not only included in that directory.
I find it included in 88 source files throughout the kernel tree.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
