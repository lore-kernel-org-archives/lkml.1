Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZKJOs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZKJOs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZKJOsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:48:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbZKJOsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:48:24 -0500
Date: Tue, 10 Nov 2009 16:45:44 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: alacrityvm-devel@lists.sourceforge.net, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
Message-ID: <20091110144543.GC19645@redhat.com>
References: <20091002141407.30224.54207.stgit@dev.haskins.net> <20091110115335.GC6989@redhat.com> <4AF919020200005A000586A9@sinclair.provo.novell.com> <20091110131722.GA19645@redhat.com> <4AF9747E.8020408@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9747E.8020408@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 09:11:10AM -0500, Gregory Haskins wrote:
> > You are comparing with skb destructors, not skb data destructors :) skb
> > data destructor is Rusty's patch which he wanted to use for vringfd.  I
> > mean e.g. this:
> > http://lists.openwall.net/netdev/2008/04/18/7
> 
> Ah, I wasn't aware.  I believe Anthony Ligouri had pointed me at this
> same patch earlier this year.  However, more recently when I saw
> skb->destructor() in mainline (seemingly from Rusty), I thought it had
> been accepted and didn't investigate further.

skb->destructor seems to be there as far back as 2.2.0
http://lxr.linux.no/#linux-old+v2.2.0/include/linux/skbuff.h

-- 
MST
