Return-Path: <linux-kernel-owner+w=401wt.eu-S1763421AbXEPUd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763421AbXEPUd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbXEPUdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:33:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43109 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758281AbXEPUdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:33:49 -0400
Date: Wed, 16 May 2007 13:33:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Oleg Nesterov <oleg@tv-sign.ru>, Alex Dubov <oakad@yahoo.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [2/3] 2.6.22-rc1: known regressions v2
In-Reply-To: <464B6A2B.9020703@googlemail.com>
Message-ID: <Pine.LNX.4.64.0705161333140.11079@schroedinger.engr.sgi.com>
References: <464B6743.9000607@googlemail.com> <464B6A2B.9020703@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Michal Piotrowski wrote:

> Memory management
> 
> Subject    : kernel BUG at include/linux/slub_def.h:88 kmalloc_index()
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8476
> Submitter  : Cherwin R. Nooitmeer <cherwin@gmail.com>
> Status     : Unknown


This a kmalloc(0) that needs fixing.
