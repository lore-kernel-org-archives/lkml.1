Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZEEPzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZEEPzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZEEPyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:54:52 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49290 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZEEPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:54:51 -0400
Date: Tue, 5 May 2009 11:43:58 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, torvalds@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com,
       riel@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       npiggin@suse.de
Subject: Re: [RFC][PATCH] vmscan: don't export nr_saved_scan in
 /proc/zoneinfo
In-Reply-To: <1241509090.11059.31.camel@twins>
Message-ID: <alpine.DEB.1.10.0905051142580.11830@qirst.com>
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org>  <20090501012212.GA5848@localhost>  <20090430194907.82b31565.akpm@linux-foundation.org>  <20090502023125.GA29674@localhost> <20090502024719.GA29730@localhost>  <20090504144915.8d0716d7.akpm@linux-foundation.org>
 <1241509090.11059.31.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Peter Zijlstra wrote:

> > /proc/zoneinfo is unsalvageable :( Shifting future work over to
> > /sys/devices/system/node/nodeN/meminfo and deprecating /proc/zoneinfo
> > sounds good to me.
>
> If only one could find things put in sysfs :-)

Write a "zoneinfo" command line tool to show this information? If we
cannot output large texts via /proc or /sys then we need small tools for
all sorts of statistics.

