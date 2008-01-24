Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYAXOvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYAXOvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYAXOve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:51:34 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58119 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbYAXOvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:51:33 -0500
Date: Thu, 24 Jan 2008 09:51:32 -0500
To: Marcin Gil <marcin.gil@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
Message-ID: <20080124145132.GE16171@csclub.uwaterloo.ca>
References: <200801232323.36187.marcin.gil@gmail.com> <20080123234639.025cc859@lxorguk.ukuu.org.uk> <479839B4.3060202@gmail.com> <20080124142717.GA16173@csclub.uwaterloo.ca> <4798A114.6010803@gmail.com> <20080124144359.GD16171@csclub.uwaterloo.ca> <4798A537.9000104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4798A537.9000104@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 03:48:23PM +0100, Marcin Gil wrote:
> Yes, this is 80-wire cable; both are connected on the same cable. HDD is 
> master and DVD is slave. I'll later try disconnecting DVD and see what 
> happens. I didn't set cable-select due to how these drives are connected
> 
> +-----+-----+
> mobo  hdd   dvd
> 
> I think that cable select would take dvd as master and hdd as slave.
> This was not preferable when hdd was my primary drive. I can try 
> cable-select now since I boot off new SATA drive.

Does the BIOS see the HD on the jmicron when doing disk detection?

I remember once forgetting to connect power to a driver and spending a
while wondering why the drive wasn't showing up anywhere.

--
Len Sorensen
