Return-Path: <linux-kernel-owner+w=401wt.eu-S932845AbZHGSlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbZHGSlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbZHGSlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:41:39 -0400
Received: from ru.mvista.com ([213.79.90.228]:2009 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932527AbZHGSlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:41:39 -0400
Date: Fri, 7 Aug 2009 22:41:38 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@fluff.org>, linux-kernel@vger.kernel.org,
       sdhci-devel@lists.ossman.eu, linuxppc-dev@ozlabs.org,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 0/4] sdhci-of: Some fixes for high-speed and 4-bit SD
 cards
Message-ID: <20090807184138.GA22322@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090807163940.GA29192@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090807163940.GA29192@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 08:39:40PM +0400, Anton Vorontsov wrote:
> Hi all,
> 
> Finally I've got a bunch of SD cards to test eSDHC in various ways,
> and more importantly now I have a lot of SDHS cards. ;-)
> 
> So, here are few fixes that make eSDHC work flawlessly on MPC83xx
> SOCs with all SD and MMC cards that I have.
> 
> On MPC85xx (namely MPC8536 and MPC8569) SOCs there is one issue:
> the cards can be detected and read just fine, but writing doesn't
> work (no interrupts received). I'm currently investigating this.

Solved. It appears that eSDHC on MPC85xx has a normal write-protect
reporting. And eSDHC actually checks the WP pin, thus doesn't let
anybody to do any writes... I'll make some additional patches and
will send v2 soon.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
