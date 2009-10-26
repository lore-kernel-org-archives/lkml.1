Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZJZHyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZJZHyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZJZHyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:54:40 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48814 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbZJZHyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A7cYRaWCkJhUGQF7FkHui5GrA50Zvx7hufje1ot55iDDES9CmvY7w2d+4uTl5Itm67
         Z9j+4w/wcptJVw72hHTtDYc3+oVrl0iDqwmvi4TjUjEjCD+J3dZdFh3lzJU8x1i9s0mM
         OZ/PFP/so8IGCq2AoT4AWY8ANPbxhEvmr6LSI=
Date: Mon, 26 Oct 2009 07:54:38 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
Message-ID: <20091026075438.GB6187@ff.dom.local>
References: <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc> <20091021211906.GA11401@ami.dom.local> <1256160330.12174.2.camel@johannes.local> <20091021213947.GA12202@ami.dom.local> <1256200021.12174.11.camel@johannes.local> <4AE1C00B.5010008@imap.cc> <1256309191.12174.51.camel@johannes.local> <20091026074126.GA6187@ff.dom.local> <1256543054.28230.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256543054.28230.6.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 08:44:14AM +0100, Johannes Berg wrote:
> On Mon, 2009-10-26 at 07:41 +0000, Jarek Poplawski wrote:
> 
> > > netif_rx_ni() disables preemption.
> > 
> > You wrote earlier:
> > 
> > > [...] the networking layer needs to have
> > > packets handed to it with softirqs disabled.
> > 
> > How disabling preemption can fix something which needs softirqs
> > disabled? Could you be more precise?
> 
> No, I wrote that I didn't know. I suppose now that I looked at it I do
> know, and only disabling preemption is required.

But netif_rx has preemption disabled most of the time (by hardirqs
disabling). So maybe disabling preemption isn't the main reason here
either?

Jarek P.
