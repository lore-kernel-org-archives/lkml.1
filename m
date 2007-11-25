Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbXKYE3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbXKYE3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 23:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXKYE30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 23:29:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995AbXKYE3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 23:29:25 -0500
Date: Sat, 24 Nov 2007 20:28:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "Simon Arlott" <simon@fire.lp0.eu>,
       "Francois Romieu" <romieu@fr.zoreil.com>,
       "Kai Ruhnau" <kai@tragetaschen.dyndns.org>,
       "LKML" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Bogus PCI vendor ID
Message-Id: <20071124202815.fed44890.akpm@linux-foundation.org>
In-Reply-To: <20071119092736.7cb21231@freepuppy.rosehill>
References: <473F0FE0.3010501@tragetaschen.dyndns.org>
	<20071117184030.GA5541@electric-eye.fr.zoreil.com>
	<53552.simon.1195474940@5ec7c279.invalid>
	<20071119092736.7cb21231@freepuppy.rosehill>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 09:27:36 -0800 Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> On Mon, 19 Nov 2007 12:22:20 -0000
> "Simon Arlott" <simon@fire.lp0.eu> wrote:
> 
> > On Sat, November 17, 2007 18:40, Francois Romieu wrote:
> > > Kai Ruhnau <kai@tragetaschen.dyndns.org> :
> > > [...]
> > >> I have a problem with two of my PCI devices showing the wrong PCI vendor
> > >> ID (0001) in vanilla kernels.
> > 

Please try CONFIG_PCI_MMCONFIG=n
