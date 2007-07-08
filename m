Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbXGHEhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbXGHEhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 00:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXGHEhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 00:37:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38122
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbXGHEha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 00:37:30 -0400
Date: Sat, 07 Jul 2007 21:37:52 -0700 (PDT)
Message-Id: <20070707.213752.63129539.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality,
 performance and maintenance
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070708034952.022985379@sgi.com>
References: <20070708034952.022985379@sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Sat, 07 Jul 2007 20:49:52 -0700

> A cmpxchg is less costly than interrupt enabe/disable

This is cpu dependant, and in fact not true at all on Niagara
and several of the cpus in the UltraSPARC family.
