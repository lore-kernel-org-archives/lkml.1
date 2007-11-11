Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbXKKXn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbXKKXn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 18:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXKKXnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 18:43:22 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:63296 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbXKKXnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 18:43:21 -0500
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=NY5VCyCWsYa3YErZcJ3KrUMYN9xdmv/3wNxOJQuDjv1cyrIFynb5zEzq8mp4Co+oS5gILPb8SXh06SJgkbJaiQBYgvQQCYMER0QLRa/0POKjZ3+RBj5Gpx9JexR2UOmP;
X-IronPort-AV: E=Sophos;i="4.21,402,1188795600"; 
   d="scan'208";a="412549876"
Date: Sun, 11 Nov 2007 17:43:13 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Keith Chew <keith.chew@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCI card initialisation at boot
Message-ID: <20071111234313.GB15880@auslistsprd01.us.dell.com>
References: <20f65d530711110722k3d2bf658hb44ceaa036b9962c@mail.gmail.com> <20071111164644.7b2c743c@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071111164644.7b2c743c@the-village.bc.nu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 04:46:44PM +0000, Alan Cox wrote:
> Linux by default uses the BIOS resource assignments. It doesn't know
> where those came from other than "the BIOS".

Slightly tangential, but I'm starting to hear requests to have the OS
re-assign resources when it might make better sense.  For example, if
you have a graphics card with a 1GB memory allocation, the BIOS may
assign it into address ranges below 4GB because it doesn't know
if the OS will be 32-bit or 64-bit capable.  But, it would be
beneficial to have it located above 4GB, and to fill in the (new) hole
below 4GB with RAM.  Linux right now doesn't have a way to do this.
It will assign resources for cards that the BIOS left unassigned, but
won't intentionally move resources.


-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
