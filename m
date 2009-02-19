Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZBSHbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZBSHbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 02:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZBSHbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 02:31:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:54379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZBSHbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 02:31:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=DCGJ0tdFAmyvjxu/S/kGLF4hAo16XScP2y1GYRtPGhE/OcNjbNzBJAaSB6rFnDPnqu
         k30FIhSJYHJZiSWWhm0gcx4nYQGsc3qQj7x1ujggUsThltY4IEOP6LdXPa9oATF0yUr6
         6IB+P+6DyCEDh534XtE11ms07AyQiJYBNZSBk=
Date: Thu, 19 Feb 2009 07:30:55 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: problem with IPoA (CLIP),  NAT, and VLANS
Message-ID: <20090219073055.GA4564@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218210507.GA2698@ami.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-02-2009 22:05, Jarek Poplawski wrote:
...
> depending on your config or even size of packets. So I guess, knowing
> this all, you should better try to hack this driver more yet.

...And the first step could be trying skb_copy() in the driver's
->hard_start_xmit() callback (of course, if you prefer data safety
over perfomance).

Jarek P.
