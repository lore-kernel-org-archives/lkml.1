Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXCABde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXCABde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbXCABde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:33:34 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:44167 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953AbXCABdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:33:33 -0500
Date: Wed, 28 Feb 2007 20:33:32 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Charles Shannon Hendrix <shannon@widomaker.com>
Subject: Re: 2.6.20 SATA error
In-Reply-To: <45E61C9C.4080401@shaw.ca>
Message-ID: <Pine.LNX.4.64.0702282032560.11020@mtl.rackplans.net>
References: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no>
 <fa.OO5sHloeJxxBmHwyt7Swo5eydUY@ifi.uio.no> <fa.G7ZWCF8iZMzCCHcWS6votbmzA3U@ifi.uio.no>
 <fa.GSOUb36DPlkk7gFXS5FtJVpQIq0@ifi.uio.no> <fa.Evhbh+iC4EjQWXsDSWHX9shqJXc@ifi.uio.no>
 <45E60E36.2070709@shaw.ca> <Pine.LNX.4.64.0702281825200.11020@mtl.rackplans.net>
 <45E61C9C.4080401@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Robert Hancock wrote:

> Date: Wed, 28 Feb 2007 18:21:48 -0600
> From: Robert Hancock <hancockr@shaw.ca>
> To: Gerhard Mack <gmack@innerfire.net>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>,
>     Charles Shannon Hendrix <shannon@widomaker.com>
> Subject: Re: 2.6.20 SATA error
> 
> Gerhard Mack wrote:
> > > > Sorry for the false alarm, 
> > > There is one thing that seems odd, if you do have an nForce4 chipset, the
> > > kernel should be running the SATA controller in ADMA mode in 2.6.20, but
> > > it
> > > doesn't seem like it is from your dmesg output. Can you post the output of
> > > "lspci -vvn"? Also what kind of motherboard is that?
> > > 
> > Sure thing.  It's an Asus m2npv-vm.
> 
> Ah, that would be why, it's not one of the original nForce4 (CK804/MCP04)
> chipsets, it's the newer nForce 430 (MCP51) chipset which doesn't support
> ADMA. NVidia said they'd be sending some patches to allow NCQ support on MCP51
> and MCP61 chipsets back in October, but I haven't seen any, or information
> required to implement same..

fun stuff.. I guess it's back to trying to get the onboard ethernet card 
to work in debian.

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
