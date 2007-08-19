Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbXHSWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbXHSWcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXHSWcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:32:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1560 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbXHSWcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:32:01 -0400
Subject: Re: [PATCH 4/5] Documentation/firmware/... convert #include
	"linux/..." to #include <linux/...>
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Markus Rechberger <markus.rechberger@amd.com>
In-Reply-To: <20070819153422.1e0b54af.randy.dunlap@oracle.com>
References: <1187561972.4200.143.camel@localhost>
	 <20070819153422.1e0b54af.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Sun, 19 Aug 2007 15:31:57 -0700
Message-Id: <1187562717.4200.154.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-19 at 15:34 -0700, Randy Dunlap wrote:
> > -#include "linux/firmware.h"
> > +#include "firmware.h"
> I believe that it should be <linux/firmware.h>.

OK.

That's not my taste though, especially if only
included by files in the firmware_class directory.
Less pollution/namespace collision in include/linux

cheers,  Joe

