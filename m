Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZIWJXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZIWJXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZIWJXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:23:23 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:49592 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZIWJXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:23:22 -0400
X-SourceIP: 213.93.53.227
Subject: Re: regression in page writeback
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
In-Reply-To: <1253697598.2277.13.camel@castor>
References: <1253601612.8439.274.camel@twins>
	 <20090922080505.GB9192@localhost> <1253606965.8439.281.camel@twins>
	 <20090922082427.GA24888@localhost> <1253608335.8439.283.camel@twins>
	 <20090922155259.GL10825@think> <20090923002220.GA6382@localhost>
	 <20090922175452.d66400dd.akpm@linux-foundation.org>
	 <20090923011758.GC6382@localhost>
	 <20090922182832.28e7f73a.akpm@linux-foundation.org>
	 <20090923014500.GA11076@localhost>
	 <20090922185941.1118e011.akpm@linux-foundation.org>
	 <1253697598.2277.13.camel@castor>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 11:23:31 +0200
Message-Id: <1253697811.7695.127.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 10:19 +0100, Richard Kennedy wrote:
> 
> I am concerned that the background writeout no longer stops when it
> reaches the background threshold, as balance_dirty_pages requests all
> dirty pages to be written. No doubt this is good for large linear writes
> but what about more random write workloads? 

I've not had time to look over the current code, but write-out not
stopping on reaching background threshold is a definite bug and needs to
get fixed.

