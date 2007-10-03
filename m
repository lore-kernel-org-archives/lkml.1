Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbXJCROT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbXJCROT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXJCROL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:14:11 -0400
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:42440 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751608AbXJCROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:14:10 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: akepner@sgi.com
Subject: Re: [PATCH 0/4] allow drivers to flush in-flight DMA v2
Date: Wed, 3 Oct 2007 10:10:53 -0700
User-Agent: KMail/1.9.7
Cc: David Miller <davem@davemloft.net>, grundler@parisc-linux.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
References: <20070928010926.GM30013@sgi.com> <20070928.154339.02281405.davem@davemloft.net> <20071003010455.GD26752@sgi.com>
In-Reply-To: <20071003010455.GD26752@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710031010.54518.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 2, 2007 6:04 pm akepner@sgi.com wrote:
> On Fri, Sep 28, 2007 at 03:43:39PM -0700, David Miller wrote:
> > ....
> > My only beef with this patch set is that it seems
> > a bit much to create a totally new function name every
> > time we want to set some kind of new attribute on some
> > DMA object.  Why not add a "dma_set_flags()" or similar
> > that can be used later on to set other kinds of aspects
> > we'd like to change?
> >
> > You can make the arguments "u32 flags" and "int dir".
> > Actually you should probably use the dma direction
> > enumaration instead of 'int'.
>
> OK, this will be in the next version along with the
> coding style changes you mentioned.

I can't find it now, but IIRC Dave, you vehemently opposed adding a 
flags argument awhile back (~2000), so SGI has been reluctant to push 
it again. :)

Glad you're finally coming around, I think a flags argument makes sense, 
as long as we're careful about adding new ones.

Jesse
