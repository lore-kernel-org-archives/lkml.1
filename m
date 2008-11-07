Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYKGUub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYKGUub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYKGUuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:50:24 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4993 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYKGUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:50:23 -0500
Subject: Re: [PATCH 4/5] adt7473: Check inputs from sysfs writes
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, khali@linux-fr.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
In-Reply-To: <20081107112040.0154e093.akpm@linux-foundation.org>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	 <20081107185641.13022.70557.stgit@elm3a70.beaverton.ibm.com>
	 <20081107112040.0154e093.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 12:49:34 -0800
Message-Id: <1226090974.10478.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 11:20 -0800, Andrew Morton wrote:
> > +#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
> It might make sense to rename this to ROUND_CLOSEST, fix the
> double-evaluation and whap it into kernel.h?

ROUND_HALF_UP?

