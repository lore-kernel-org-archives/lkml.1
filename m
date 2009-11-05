Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZKEN5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZKEN5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZKEN5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:57:24 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:30045 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbZKEN5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:57:23 -0500
Subject: Re: Shared i2c adapter locking
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
In-Reply-To: <20091105141122.56b6b4f8@hyperion.delvare>
References: <20091026133757.7cf87e49.sfr@canb.auug.org.au>
	 <20091029154317.651904b9@hyperion.delvare>
	 <1256828976.2827.27.camel@achroite>
	 <20091105141122.56b6b4f8@hyperion.delvare>
Content-Type: text/plain; charset=utf-8
Organization: Solarflare Communications
Date: Thu, 05 Nov 2009 13:57:24 +0000
Message-Id: <1257429444.2793.2.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Nov 2009 13:57:28.0214 (UTC) FILETIME=[E9273B60:01CA5E1F]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.600.1016-16990.004
X-TM-AS-Result: No--13.455700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 14:11 +0100, Jean Delvare wrote:
[...]
> What about the following patch?
> 
> From: Jean Delvare <khali@linux-fr.org>
> Subject: i2c: Add an interface to lock/unlock I2C bus segment
> 
> Some drivers need to be able to prevent access to an I2C bus segment
> for a specific period of time. Add an interface for them to do so
> without twiddling with i2c-core internals.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Ben Hutchings <bhutchings@solarflare.com>
Acked-by: ﻿Ben Hutchings <bhutchings@solarflare.com>

Presumably this is meant for net-next-2.6, and you'll implement
i2c_{lock,unlock}_adapter() using rt_mutex in your i2c tree?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

