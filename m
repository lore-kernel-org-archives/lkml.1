Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbYBNX5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbYBNX5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYBNX4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:56:54 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:60080 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753481AbYBNX4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:56:53 -0500
Date: Thu, 14 Feb 2008 23:56:37 +0000
From: Ben Dooks <ben@fluff.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ubi: fix sparse errors in ubi.h
Message-ID: <20080214235637.GA4715@fluff.org.uk>
References: <1203025995.5601.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203025995.5601.0.camel@brick>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 01:53:15PM -0800, Harvey Harrison wrote:
> In C, signed 1-bit bitfields can only take the values 0 and -1, only
> 0 and 1 are ever assigned in current code.  Make them unsigned
> bitfields.
> 
> Fixes the (repeated) sparse errors:
> drivers/mtd/ubi/ubi.h:220:15: error: dubious one-bit signed bitfield
> drivers/mtd/ubi/ubi.h:221:17: error: dubious one-bit signed bitfield
> drivers/mtd/ubi/ubi.h:222:18: error: dubious one-bit signed bitfield
> drivers/mtd/ubi/ubi.h:223:16: error: dubious one-bit signed bitfield
> drivers/mtd/ubi/ubi.h:224:20: error: dubious one-bit signed bitfield
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Sorry, not sure who to CC on this.

IIRC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
