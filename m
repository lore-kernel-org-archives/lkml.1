Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZGEJz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZGEJz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZGEJzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:55:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40168 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZGEJzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:55:19 -0400
Date: Sun, 5 Jul 2009 11:55:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Xeon 5500 series support in kernel
Message-ID: <20090705095520.GP2041@one.firstfloor.org>
References: <4A4C770F.6000709@bull.net> <877hyrbeon.fsf@basil.nowhere.org> <87k52o65gk.fsf@hades.wkstn.nix> <20090704160743.GA19804@basil.fritz.box> <520B2A28AACEE94388C511BBB834933707AA86AEA1@IGR-IMC-01.corp.win-professional.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520B2A28AACEE94388C511BBB834933707AA86AEA1@IGR-IMC-01.corp.win-professional.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 04, 2009 at 08:01:44PM +0200, Morten P.D. Stevens wrote:
> Hi Andi,
> 
> a general question with regard to the new intel nehalem platform:
> 
> Which linux version is needed for an intel nehalem based xeon in view of the new intel 5500/5520 chipset drivers?
> 
> Does it work with 2.6.18? (Debian Etch)

You would need backported drivers for Ethernet etc; the plain
integrated drivers in 2.6.18 will not work. The e1000 project
at sourceforge has driver backports for Ethernet.

I don't know if Debian does regular backports of drivers,
some other distributions with support for old kernels do.

Also some power saving features and performance features 
which are related to power saving (turbo mode) will not work in that old a 
kernel. For full performance it's better to use newer kernels or
kernels with appropiate backports.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
