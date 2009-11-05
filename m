Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZKEOHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZKEOHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbZKEOH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:07:29 -0500
Received: from bamako.nerim.net ([62.4.17.28]:59471 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbZKEOH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:07:28 -0500
Date: Thu, 5 Nov 2009 15:07:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: Shared i2c adapter locking
Message-ID: <20091105150715.692b5200@hyperion.delvare>
In-Reply-To: <1257429444.2793.2.camel@achroite.uk.solarflarecom.com>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	<20091029154317.651904b9@hyperion.delvare>
	<1256828976.2827.27.camel@achroite>
	<20091105141122.56b6b4f8@hyperion.delvare>
	<1257429444.2793.2.camel@achroite.uk.solarflarecom.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Nov 2009 13:57:24 +0000, Ben Hutchings wrote:
> On Thu, 2009-11-05 at 14:11 +0100, Jean Delvare wrote:
> [...]
> > What about the following patch?
> > 
> > From: Jean Delvare <khali@linux-fr.org>
> > Subject: i2c: Add an interface to lock/unlock I2C bus segment
> > 
> > Some drivers need to be able to prevent access to an I2C bus segment
> > for a specific period of time. Add an interface for them to do so
> > without twiddling with i2c-core internals.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Ben Hutchings <bhutchings@solarflare.com>
> Acked-by: ﻿Ben Hutchings <bhutchings@solarflare.com>
> 
> Presumably this is meant for net-next-2.6, and you'll implement

Actually I meant to push this to Linus immediately, through my i2c
tree. This is essentially a no-op: the binary code will be the same as
before the patch, so guaranteed to be safe, and this will solve
conflicts in linux-next.

> i2c_{lock,unlock}_adapter() using rt_mutex in your i2c tree?

Correct.

-- 
Jean Delvare
