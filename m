Return-Path: <linux-kernel-owner+w=401wt.eu-S964935AbXDWQIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbXDWQIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965095AbXDWQIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:08:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42793 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964935AbXDWQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:08:05 -0400
Date: Mon, 23 Apr 2007 09:08:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
In-Reply-To: <1177343900.26937.6.camel@twins>
Message-ID: <Pine.LNX.4.64.0704230907470.11250@schroedinger.engr.sgi.com>
References: <20070420155154.898600123@chello.nl>  <20070420155503.608300342@chello.nl>
  <20070421025532.916b1e2e.akpm@linux-foundation.org>  <1177156902.2934.96.camel@lappy>
 <1177157708.2934.100.camel@lappy>  <Pine.LNX.4.64.0704230847400.10624@schroedinger.engr.sgi.com>
 <1177343900.26937.6.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Peter Zijlstra wrote:

> Ooh, thats handy... /me ditches the hotplug code again.
> That is, unless its very common to have half empty boxens.. ?

Its up to the arch code to establish reasonable boundaries.....

