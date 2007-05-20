Return-Path: <linux-kernel-owner+w=401wt.eu-S1764720AbXETHMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764720AbXETHMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 03:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXETHMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 03:12:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54081 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759342AbXETHMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 03:12:32 -0400
Date: Sun, 20 May 2007 00:12:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070520030934.33447.qmail@web52609.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705200011200.18989@schroedinger.engr.sgi.com>
References: <20070520030934.33447.qmail@web52609.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Srihari Vijayaraghavan wrote:

> Code: 0f ob eb fe 48 8b 1b 48 8b 0x 0f 18 08 48 81 fb 60 cb 51 80
> RIP [...] slab_sysfs_init+0x49/0x98
> RSP [...]
> kernel panic - not syncing: Attempted to kill init!

sysfs? If you build without CONFIG_SLUB_DEBUG then SLUB will not use 
sysfs. You can switch that off in the embedded section.
