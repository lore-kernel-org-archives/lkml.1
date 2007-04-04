Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXDDSDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXDDSDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXDDSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:03:09 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:57591 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbXDDSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:03:06 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17939.59480.445304.429384@gargle.gargle.HOWL>
Date: Wed, 4 Apr 2007 22:03:04 +0400
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] maps: Add /proc/pid/pagemap interface
In-Reply-To: <20070404163232.GV4892@waste.org>
References: <1.486631555@selenic.com>
	<13.486631555@selenic.com>
	<17939.35217.938339.677599@gargle.gargle.HOWL>
	<20070404163232.GV4892@waste.org>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0001716 6d7c003f6b397b0b7c61999c80b345e8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall writes:

[...]

 > 
 > Now I could adjust these to only export u64s in some preferred
 > endianness. But given I already need details like the page size to
 > make any sense of it, it seems unnecessary. Also, the PFNs are fairly
 > opaque unless you're attempting to correlate them with /proc/kpagemap.

Alternatively, you can export some meta-data at the beginning of that
file like /proc/profile does.

Nikita.

