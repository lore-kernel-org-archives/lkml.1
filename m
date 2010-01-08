Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192Ab0AHWCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab0AHWCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136Ab0AHWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:02:35 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36596 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0AHWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:02:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SlEsNKJnL+hMpf3NsWYe/Jgl9wgUOhSDLTX9vHirisExEPm/9F+cS4CsuLzUpCkSCZ
         rIu14jVJ0d7eRfRXldi+mahAhD4CdL5kzO+RFgYIneu+TOBtq3vlH/k90+9BbTuZ0Lde
         XmbWHDo/SWby/6YQjZSLROhjEpJsBu2nO4/3E=
Date: Fri, 8 Jan 2010 23:02:28 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100108220228.GB3078@del.dom.local>
References: <20100107180114.GB3088@del.dom.local>
 <4B4625BD.3070202@majjas.com>
 <20100107183545.GA3208@del.dom.local>
 <4B462B3C.90506@majjas.com>
 <20100107185040.GB3208@del.dom.local>
 <4B466A26.5070506@majjas.com>
 <20100108074539.GA6205@ff.dom.local>
 <4B475FF9.7000702@majjas.com>
 <20100108212923.GA3078@del.dom.local>
 <4B47A81B.5040601@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B47A81B.5040601@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 04:48:11PM -0500, Michael Breuer wrote:
> On 1/8/2010 4:29 PM, Jarek Poplawski wrote:
> >On Fri, Jan 08, 2010 at 11:40:25AM -0500, Michael Breuer wrote:
> >>On 1/8/2010 2:45 AM, Jarek Poplawski wrote:
> >>...
> >Berck Nash reported oopses during sky2 TX timeout recovery, which are
> >generally hardware/driver problems, and shouldn't be triggered by ip
> >level bugs, so it should be queried as a separate bug report.
> >
> My thought was that his crash was secondary to the netdev watchdog &
> subsequent reset that I saw.

Yes, the netdev watchdog which triggers on TX timeout.

Jarek P.
