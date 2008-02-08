Return-Path: <linux-kernel-owner+w=401wt.eu-S933988AbYBHUd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbYBHUd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbYBHUdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:33:46 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3809 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbYBHUdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:33:45 -0500
Subject: Re: [PATCH] mm/slub.c - Use print_hex_dump
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802081224100.5358@schroedinger.engr.sgi.com>
References: <1202493808.27394.76.camel@localhost>
	 <Pine.LNX.4.64.0802081006460.28568@schroedinger.engr.sgi.com>
	 <1202495069.27394.85.camel@localhost>
	 <Pine.LNX.4.64.0802081031320.28862@schroedinger.engr.sgi.com>
	 <1202501739.27394.96.camel@localhost>
	 <Pine.LNX.4.64.0802081224100.5358@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:33:18 -0800
Message-Id: <1202502798.27394.100.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 12:25 -0800, Christoph Lameter wrote:
> Argh. You need to cut that into small pieces so that it is easier to 
> review. CCing Randy who was involved with prior art in this area.

lib/hexdump is the major change.
mm/slub is a removal/conversion.
the rest are trivial.


