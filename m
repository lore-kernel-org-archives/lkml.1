Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYKGVAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYKGVAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYKGVAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:00:38 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:30180 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYKGVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:00:38 -0500
Date: Fri, 7 Nov 2008 22:00:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 4/5] adt7473: Check inputs from sysfs writes
Message-ID: <20081107220019.74c60aa4@hyperion.delvare>
In-Reply-To: <1226090974.10478.15.camel@localhost>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	<20081107185641.13022.70557.stgit@elm3a70.beaverton.ibm.com>
	<20081107112040.0154e093.akpm@linux-foundation.org>
	<1226090974.10478.15.camel@localhost>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 12:49:34 -0800, Joe Perches wrote:
> On Fri, 2008-11-07 at 11:20 -0800, Andrew Morton wrote:
> > > +#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
> > It might make sense to rename this to ROUND_CLOSEST, fix the
> > double-evaluation and whap it into kernel.h?
> 
> ROUND_HALF_UP?

What would that supposedly mean?

-- 
Jean Delvare
