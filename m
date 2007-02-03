Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXBCW66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXBCW66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 17:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbXBCW65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 17:58:57 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:46400 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXBCW65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 17:58:57 -0500
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20070203005316.eb0b4042.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
	 <20070203005316.eb0b4042.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 04 Feb 2007 09:58:55 +1100
Message-Id: <1170543535.23664.44.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On Sat, 2007-02-03 at 00:53 -0800, Andrew Morton wrote:
> > 1. We use the 21st page flag and we only have 20 on 32 bit NUMA platforms.
> 
> Ow.  How were you thinking of fixing that?

Oh, guess the dyn_pageflags patch is not needed then - the dangers of
replying before reading a whole thread :)

Nigel

