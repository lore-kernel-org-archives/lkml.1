Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXKSR2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXKSR2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 12:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbXKSR2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 12:28:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101AbXKSR2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:28:13 -0500
Date: Mon, 19 Nov 2007 09:27:36 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Simon Arlott" <simon@fire.lp0.eu>
Cc: "Francois Romieu" <romieu@fr.zoreil.com>,
       "Kai Ruhnau" <kai@tragetaschen.dyndns.org>,
       "LKML" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Bogus PCI vendor ID
Message-ID: <20071119092736.7cb21231@freepuppy.rosehill>
In-Reply-To: <53552.simon.1195474940@5ec7c279.invalid>
References: <473F0FE0.3010501@tragetaschen.dyndns.org>
	<20071117184030.GA5541@electric-eye.fr.zoreil.com>
	<53552.simon.1195474940@5ec7c279.invalid>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 12:22:20 -0000
"Simon Arlott" <simon@fire.lp0.eu> wrote:

> On Sat, November 17, 2007 18:40, Francois Romieu wrote:
> > Kai Ruhnau <kai@tragetaschen.dyndns.org> :
> > [...]
> >> I have a problem with two of my PCI devices showing the wrong PCI vendor
> >> ID (0001) in vanilla kernels.
> 
> Have you tried doing a cold boot at every test? I've had bogus PCI IDs
> appear before where it was the device's fault, and the ID would change
> after the first boot.
> 

With LAN devices you may even need to pull the plug because WOL will
keep the device in a warmstart state.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
