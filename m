Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbZDCLRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbZDCLRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762452AbZDCLRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:17:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46343 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761725AbZDCLRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:17:08 -0400
Date: Fri, 3 Apr 2009 13:18:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       ghaskins@novell.com, anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
Message-ID: <20090403111854.GA11935@one.firstfloor.org>
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D5EBE1.8030200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D5EBE1.8030200@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Check shared ring status when stuffing a request.  If there are requests

That means you're bouncing cache lines all the time. Probably not a big
issue on single socket but could be on larger systems.

-Andi

