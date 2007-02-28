Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbXB1WV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbXB1WV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 17:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932517AbXB1WV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 17:21:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:40899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbXB1WV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 17:21:28 -0500
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] vlan & net drivers: avoid a 4-order allocation
Date: Wed, 28 Feb 2007 14:20:13 -0800
Organization: OSDL
Message-ID: <20070228142013.17dc0367@freekitty>
References: <20070228124157.GA1589@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1172701213 30088 10.8.0.54 (28 Feb 2007 22:20:13 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Wed, 28 Feb 2007 22:20:13 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 14:41:57 +0200
Dan Aloni <da-x@monatomic.org> wrote:

> Hello,
> 
> This patch splits the vlan_group struct into a multi-allocated struct. On
> x86_64, the size of the original struct is a little more than 32KB, causing
> a 4-order allocation, which is prune to problems caused by buddy-system 
> external fragmentation conditions.
> 
> I couldn't just use vmalloc() because vfree() cannot be called in the
> softirq context of the RCU callback.
> 
> Signed-off-by: Dan Aloni <da-x@monatomic.org>
> 

Please submit patch to proper place: netdev@vger.kernel.org
and Ben Greear <greearb@candelatech.com>



-- 
Stephen Hemminger <shemminger@linux-foundation.org>
