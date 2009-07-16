Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbZGPQV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbZGPQV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbZGPQV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:21:59 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56072 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932686AbZGPQV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:21:58 -0400
Date: Thu, 16 Jul 2009 12:21:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [PATCH] mm: count only reclaimable lru pages v2
In-Reply-To: <20090716150901.GA31204@localhost>
Message-ID: <alpine.DEB.1.10.0907161220270.29771@gentwo.org>
References: <20090716133454.GA20550@localhost> <alpine.DEB.1.10.0907160959260.32382@gentwo.org> <20090716142533.GA27165@localhost> <1247754491.6586.23.camel@laptop> <alpine.DEB.1.10.0907161037590.7930@gentwo.org> <4A5F3C70.7010001@redhat.com>
 <20090716150901.GA31204@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Wu Fengguang wrote:

> /*
>  * The reclaimable count would be mostly accurate.
>  * The less reclaimable pages may be
>  * - mlocked pages, which will be moved to unevictable list when encountered
>  * - mapped pages, which may require several travels to be reclaimed
>  * - dirty pages, which is not "instantly" reclaimable
>  */

ok.
