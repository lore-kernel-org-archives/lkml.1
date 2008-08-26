Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYHZLcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYHZLcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYHZLce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:32:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:16766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYHZLce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OzRxUYL+yMJhUKOWT8mwlvWuQysnaEOBKJwhOTHJdjRlcNYDu5KdPFn1jsRs/Tx2UT
         MxkiEww2meTY+krsbeITeppD5QtskE4X7ATv/p66Ss7fZ26w0o4IHkdpVBbnvoWQTX+f
         NNiodvzI63qyi/AEM7H+o22PV4DGv4xs6lt4A=
Date: Tue, 26 Aug 2008 11:32:13 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080826113213.GA5991@ff.dom.local>
References: <20080826095126.GA2609@ff.dom.local> <20080826110746.GC2609@ff.dom.local> <20080826111545.GD2609@ff.dom.local> <200808261416.32315.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808261416.32315.denys@visp.net.lb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 02:16:32PM +0300, Denys Fedoryshchenko wrote:
> On Tuesday 26 August 2008, Jarek Poplawski wrote:
> > Hmm.. it isn't actually answer to your question, sorry. As I said
> > before I think we need to have more people interested in using such
> > additional options, and btw. I understood from your message that
> > disabling htb didn't solve the problem?
> >
> > Jarek P.
> Only HTB - no. If i disable softlockup debug - seems the load is less (i must 
> make sure), and if i remove HTB - it is becoming low. I will try to give 
> exact numbers in recent days.
> 

So maybe you could try again this htb patch for limiting
qdisc_watchdog_schedule()?

Jarek P.
