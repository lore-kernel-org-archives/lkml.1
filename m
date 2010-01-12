Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843Ab0ALAD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0ALAD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972Ab0ALAD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:03:57 -0500
Received: from waste.org ([173.11.57.241]:35269 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0ALAD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:03:56 -0500
Subject: Re: [PATCH] netpoll: allow execution of multiple rx_hooks per
 interface
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: danborkmann@googlemail.com, linux-kernel@vger.kernel.org,
       jmoyer@redhat.com, netdev@vger.kernel.org, netdev@oss.sgi.com
In-Reply-To: <20100111.155912.68138954.davem@davemloft.net>
References: <4B4630C0.6090206@gmail.com> <4B467A4D.9070708@gmail.com>
	 <1263252108.29868.4774.camel@calx>
	 <20100111.155912.68138954.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 18:03:45 -0600
Message-ID: <1263254625.29868.4777.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 15:59 -0800, David Miller wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Mon, 11 Jan 2010 17:21:48 -0600
> 
> > Looks pretty good. Dave?
> > 
> > Acked-by: Matt Mackall <mpm@selenic.com>
> 
> I don't like the loop for RX ARP processing.
> 
> The packet contents aren't going to change, so doing basic
> packet validation inside of the "for each RX client" loop
> of arp_reply() doesn't make any sense.

True. Dan, please help our poor compilers with some manual loop
invariant motion.

-- 
http://selenic.com : development and support for Mercurial and Linux


