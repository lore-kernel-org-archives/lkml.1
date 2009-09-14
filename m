Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZINPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZINPoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZINPoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:44:19 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:42601 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755381AbZINPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:44:19 -0400
Date: Mon, 14 Sep 2009 11:42:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Zhu Yi <yi.zhu@intel.com>
cc: Mel Gorman <mel@csn.ul.ie>, "Chatre, Reinette" <reinette.chatre@intel.com>,
       Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Krauss, Assaf" <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>
Subject: Re: iwlagn: order 2 page allocation failures
In-Reply-To: <1252897270.5650.169.camel@debian>
Message-ID: <alpine.DEB.1.10.0909141141200.24447@V090114053VZO-1>
References: <200909060941.01810.elendil@planet.nl>  <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie>  <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie>  <1252526738.30150.91.camel@rc-desk> <20090910090206.GA22276@csn.ul.ie>
  <1252617290.30150.321.camel@rc-desk>  <20090911084717.GB32497@csn.ul.ie> <1252897270.5650.169.camel@debian>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Zhu Yi wrote:

> BTW, does SLAB/SLUB guarantee size of multiple PAGE_SIZE __kmalloc()
> allocation align on PAGE_SIZE (or 256 bytes) boundary?

Page allocators guarantee page aligned data. Slab allocators do not.

You can create a slab that aligns objects on 256 byte boundary if you
want.


