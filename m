Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYGOLnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYGOLnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYGOLnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:43:31 -0400
Received: from stinky.trash.net ([213.144.137.162]:55241 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbYGOLnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:43:31 -0400
Message-ID: <487C8D60.9040405@trash.net>
Date: Tue, 15 Jul 2008 13:43:28 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: jengelh@computergmbh.de, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix netfilter xt_time's time_mt()'s use of do_div()
References: <20080711140206.982.19421.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080711140206.982.19421.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Fix netfilter xt_time's time_mt()'s use of do_div() on an s64 by using
> div_s64() instead.
> 
> This was introduced by patch ee4411a1b1e0b679c99686629b5eab5a072ce49f.

Alternatively we could use an u64 for the time. Jan, any preferences?

