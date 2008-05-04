Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYEDTzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYEDTzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYEDTzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:55:32 -0400
Received: from fmailhost04.isp.att.net ([207.115.11.54]:45490 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754119AbYEDTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:55:31 -0400
X-Originating-IP: [74.251.4.130]
Date: Sun, 4 May 2008 14:55:29 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: Need help debugging memory corruption
Message-ID: <20080504145529.2eac672e@osprey.hogchain.net>
In-Reply-To: <481DCE4C.9070805@gmail.com>
References: <20080503130951.091392ba@osprey.hogchain.net>
	<481DC731.5090303@gmail.com>
	<481DCE4C.9070805@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 May 2008 16:55:08 +0200
Jarek Poplawski <jarkao2@gmail.com> wrote:

> Jarek Poplawski wrote, On 05/04/2008 04:24 PM:
> ...
> 
> > I'm definitely with less experience, so I wonder why it can't be
> > a simple race between atl1_clean_rx_ring() and something (maybe even
> > pending atl1_intr_rx()) on the other cpu writing skb while kfreeing?
> 
> 
> Hmm... atl1_intr_rx() looks impossible, so atl1_alloc_rx_buffers()?

I booted with nosmp and the bug is *much* harder to hit, but I still
hit it once out of about 10 tries.  Does the fact that I hit it once
using nosmp disprove the race theory?
