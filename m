Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZLXQ3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZLXQ3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 11:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZLXQ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 11:29:08 -0500
Received: from keil-draco.com ([216.193.185.50]:59244 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZLXQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 11:29:08 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Berck Nash <flyboy@gmail.com>
Subject: Re: sky2 panic in 2.6.32.1 under load
Date: Thu, 24 Dec 2009 11:28:57 -0500
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
References: <4B300A2A.8040305@gmail.com> <20091223225855.4a7d00af.akpm@linux-foundation.org> <4B3390EC.5060408@gmail.com>
In-Reply-To: <4B3390EC.5060408@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912241128.57599.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 December 2009 11:03:56 am Berck Nash wrote:
> Andrew Morton wrote:
> > On Mon, 21 Dec 2009 16:52:10 -0700 "Berck E. Nash" <flyboy@gmail.com> 
wrote:
> >> Since 2.6.32, I've been getting kernel panics under heavy network load
> >> (bittorrent usage).
> >
> > Let's cc the right list and developer.
> >
> > This is a 2.6.31->2.6.32 regression?
> 
> I believe so.  Since it's intermittent and difficult to reproduce, it's
> possible (but unlikely) that I simply never triggered it under 2.6.31.

This is far from new. I have seen this under 2.6.27 when at least one botnet 
has been pointed at a server of mine and told to gain access. It has happened 
four times in the last six to eight months - and I have no easy way to capture 
the logs. But the oops that was posted looks very, very similar to what I've 
seen.

It's always an allocation error in the transmit path that leads to the panic. 
Because this is a production machine that I do not have a way to take down and 
do testing with I've not reported the problem before.

DRH
