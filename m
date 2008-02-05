Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYBEQb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYBEQb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYBEQbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:31:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:47462 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYBEQbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:31:18 -0500
Date: Tue, 5 Feb 2008 10:29:42 -0600
From: Matt Porter <mporter@kernel.crashing.org>
To: Zhang Wei <Wei.Zhang@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] Add multi mport support.
Message-ID: <20080205162942.GB20177@gate.crashing.org>
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com> <AF4B8466-C1CE-4FFB-8341-4BFC1CB76116@kernel.crashing.org> <ABF87B0B6A38C0458E319AC973ED68AEBD0677@zch01exm26.fsl.freescale.net> <EC566605-6890-4983-8700-3B15C9EFC1C5@kernel.crashing.org> <F2D2FCC7-D1ED-4DC6-BE7A-EE2755CCE125@kernel.crashing.org> <ABF87B0B6A38C0458E319AC973ED68AEBD0697@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ABF87B0B6A38C0458E319AC973ED68AEBD0697@zch01exm26.fsl.freescale.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 02:30:13PM +0800, Zhang Wei wrote:
> > -----Original Message-----
> > From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> > when we have multiple ports are the device IDs on the ports intended  
> > to be unique only to a port or unique across all ports?
> > 
> I consider each RIO controller will has its own network, the device IDs
> should be
> unique only in its port network.

This is a bad assumption IMHO. It pushes policy on to the system
designer of a RapidIO network.

It is very possible to use multiple controllers as entry points
in a single RapidIO network fabric space. The reason one would do this
is to provide optimized paths to some endpoints in the system.

If possible, there should never be a policy assumption like this in
kernel space. It's much better to assume that one may or may not
have a unique id space.

-Matt
