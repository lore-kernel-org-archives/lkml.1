Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbYBMJZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbYBMJZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbYBMJYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:24:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932387AbYBMJYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:24:45 -0500
Date: Wed, 13 Feb 2008 01:22:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Ben Nizette <bn@niasdigital.com>, netfilter-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>
Subject: Re: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
Message-Id: <20080213012231.46865608.akpm@linux-foundation.org>
In-Reply-To: <20080213101024.39347322@dhcp-252-066.norway.atmel.com>
References: <1202816761.3299.19.camel@moss.renham>
	<20080213004829.fd8afdc7.akpm@linux-foundation.org>
	<20080213101024.39347322@dhcp-252-066.norway.atmel.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:10:24 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> On Wed, 13 Feb 2008 00:48:29 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 12 Feb 2008 22:46:01 +1100 Ben Nizette <bn@niasdigital.com> wrote:
> > 
> > > 
> > > On an AVR32, root over NFS, config attached, running (from a startup
> > > script):
> > > 
> > > iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> > > 
> > > Results in (dmesg extract including a bit of context for good measure):
> > > -------------8<----------------
> > > VFS: Mounted root (nfs filesystem).
> > > Freeing init memory: 72K (90000000 - 90012000)
> > > eth0: no IPv6 routers present
> > > warning: `dnsmasq' uses 32-bit capabilities (legacy support in use)
> 
> Hmm. What does that mean? What size do capabilities normally have?

My near-namesake put than in, but I immediately forgot what it means?
