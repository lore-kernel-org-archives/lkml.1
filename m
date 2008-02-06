Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbYBFSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbYBFSLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYBFSLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:11:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50134 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYBFSLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:11:01 -0500
Date: Wed, 6 Feb 2008 19:45:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Glenn Griffin <ggriffin.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
Message-ID: <20080206184554.GA8455@one.firstfloor.org>
References: <20080206075030.GA454@one.firstfloor.org> <47a9ee5e.15538c0a.7043.05ba@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47a9ee5e.15538c0a.7043.05ba@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 09:36:11AM -0800, Glenn Griffin wrote:
> > I didn't think a module could have multiple module_inits. Are you
> > sure that works?
> 
> Indeed.  That will fail whenever ipv6 is compiled as a module.  It's
> been removed.  It snuck in from the v4 implementation, where I'm still
> having trouble understanding why it's needed there.

s/needed/used/

ipv4 is never modular so it works.

Arguably it would be cleaner if it was __initcall()

-Andi
