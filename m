Return-Path: <linux-kernel-owner+w=401wt.eu-S934352AbYBHSZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbYBHSZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934728AbYBHSY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:24:56 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3659 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934695AbYBHSYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:24:55 -0500
Subject: Re: [PATCH] mm/slub.c - Use print_hex_dump
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0802081006460.28568@schroedinger.engr.sgi.com>
References: <1202493808.27394.76.camel@localhost>
	 <Pine.LNX.4.64.0802081006460.28568@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 10:24:29 -0800
Message-Id: <1202495069.27394.85.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 10:07 -0800, Christoph Lameter wrote:
> On Fri, 8 Feb 2008, Joe Perches wrote:
> > Use the library function to dump memory
> Could you please compare the formatting of the output before and 
> after? Last time we tried this we had issues because it became a bit ugly.

The difference is the last line of the ascii is not aligned
if the length is non modulo 16.

I have sent a patch to print_hex_dump to always align.
http://lkml.org/lkml/2007/12/6/304


