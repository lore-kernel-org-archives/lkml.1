Return-Path: <linux-kernel-owner+w=401wt.eu-S965484AbXCFSR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965484AbXCFSR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965493AbXCFSR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:17:56 -0500
Received: from ping.uio.no ([129.240.78.2]:36345 "EHLO ping.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965484AbXCFSRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:17:55 -0500
X-Greylist: delayed 2058 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 13:17:54 EST
From: ilmari@ilmari.org (Dagfinn Ilmari =?utf-8?Q?Manns=C3=A5ker?=)
To: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>, shemminger@linux-foundation.org,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support II
Organization: Program-, Informasjons- og Nettverksteknologisk Gruppe, UiO
References: <20070226143127.5c74bec9@freekitty>
	<p73slcnawh3.fsf@bingen.suse.de> <20070305155714.3abe1b5e@freekitty>
	<20070305.162551.41660347.davem@davemloft.net>
	<20070306140412.GA1470@one.firstfloor.org>
Mail-Copies-To: nobody
Date: Tue, 06 Mar 2007 18:43:14 +0100
In-Reply-To: <20070306140412.GA1470@one.firstfloor.org> (Andi Kleen's message
	of "Tue, 6 Mar 2007 15:04:12 +0100")
Message-ID: <d8jlkiagte5.fsf@nygaard.ping.uio.no>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Exiscan-Spam-Score: -7.8 (-------)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Actually on rereading this: is there really any Linux port
> that emulates multiplies in software? I thought that was only
> done on really small microcontrollers or smart cards; but anything
> 32bit+ that runs Linux should have hardware multiply, shouldn't it?

SPARCv7 (sun4/sun4c) doesn't have hardware mul/div. This includes
SparcStation 1, 1+, 2, SLC, ELC, IPC and IPX.

-- 
ilmari
"A disappointingly low fraction of the human race is,
 at any given time, on fire." - Stig Sandbeck Mathisen
