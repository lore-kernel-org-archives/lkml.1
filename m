Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZBWPZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZBWPZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZBWPZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:25:41 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:48473 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZBWPZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:25:40 -0500
Date: Mon, 23 Feb 2009 15:25:36 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       cl@linux-foundation.org
Subject: Re: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when kmemcheck is enabled
Message-ID: <20090223152536.GB12909@silver.sucs.org>
References: <1235381712.6216.22.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235381712.6216.22.camel@penberg-laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 11:35:12AM +0200, Pekka Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Enabling kmemcheck in Kconfig is a painful experience. Lets make it a
> tad bit easier by inverting the dependencies to SLUB and SLAB debugging.
> As kmemcheck is more powerful than slab debugging, disable the latter
> functionality if an user enables kmemcheck.

You may also want to add something in the Documentation/kmemcheck.txt
saying that it conflicts with CONFIG_DEBUG_PAGEALLOC and
CONFIG_SLUB_DEBUG so that people realise why it is not presented as an
option...

-- 
Sitsofe | http://sucs.org/~sits/
