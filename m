Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169Ab0AFTk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0AFTk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026Ab0AFTk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:40:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:20113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab0AFTkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:40:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UX4fEQfBVFqW5tayHLI7kyCTKhPSBzfGoa/2nDjB+vk7Be0LfjLcmNyUf/gQarOr2b
         8jQT5dhrGRkW4k8QvXFjv1jdRPnLUz1HMN88HulMr9GSRmAmUOD3M+HKb8DgKKZYkqnz
         paJS2tD8XNXsAU7Ebp7avmNkAcQjl5CiWvv4c=
Date: Wed, 6 Jan 2010 20:40:17 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Michael Breuer <mbreuer@majjas.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH alt.2] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100106194017.GA3354@del.dom.local>
References: <20100105230746.GA6612@del.dom.local>
 <4B43F72C.9090004@majjas.com>
 <20100106072208.GA6711@ff.dom.local>
 <20100106091532.GA10201@ff.dom.local>
 <20100106064957.3be271b8@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106064957.3be271b8@nehalam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 06:49:57AM -0800, Stephen Hemminger wrote:
> On Wed, 6 Jan 2010 09:15:32 +0000
> Jarek Poplawski <jarkao2@gmail.com> wrote:
> 
> > tpacket_snd() can change and kfree an skb after dev_queue_xmit(),
> > which is illegal.
> > 
> > With debugging by: Stephen Hemminger <shemminger@linux-foundation.org>
> > 
> > Reported-by: Michael Breuer <mbreuer@majjas.com>
> > Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> 
> Good catch.
> Acked-by: Stephen Hemminger <shemminger@vyatta.com>

First of all, we're incredibly lucky that such a helpful guy as
Michael had misfortune to hit so helpfully broken piece of hardware ;-)

Thanks,
Jarek P.
