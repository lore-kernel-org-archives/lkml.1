Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbYEOS0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbYEOS0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYEOS00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:26:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:34836 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYEOS0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:26:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=esO+EWmRGf8PwGnAvh3rhuGlgjMzzqBxeJNWti6dpwr8SLNdlV+u3PELwNIi6eI4BnkfVYu7QEMHKHXyO+jzPUl6TgsyyDSIH8AnQsI6KOQ5hOjTtVrG6kB/F0dCwy1Q7ocHLPvqllLVgsVgkmdn20JBd8kjZEaj83N7ZC4k8CA=
Date: Thu, 15 May 2008 20:25:04 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Kingsley Foreman <kingsley@internode.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Message-ID: <20080515182504.GB2936@ami.dom.local>
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk> <482C6040.9030808@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482C6040.9030808@trash.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 06:09:36PM +0200, Patrick McHardy wrote:
...
> Do things improve if you set txqueuelen to a larger value
> *before* configuring the qdiscs?

BTW, I hope it was *before*, but since pfifo_fast_enqueue() uses
"qdisc->dev->tx_queue_len" does it really matter? (Until it's
before the test of course...)

Jarek P.
