Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbYCLKrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbYCLKrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYCLKrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:47:14 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:42452 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYCLKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:47:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=IiW+JvJRu1uknMeQu/D1iHKxNnZi2FkE4ZXrXUG4BR5gT8vSUOxZX3xHuGHms
	TGN3XVs7wxM5bUddZ2Dg3TdZQ==
Date: Wed, 12 Mar 2008 11:47:11 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>,
       Rabeeh Khoury <rabeeh@marvell.com>
Subject: Re: ehci watchdog-related splatter in 2.6.25-rc4
Message-ID: <20080312104711.GA24754@xi.wantstofly.org>
References: <20080312093045.GA24017@xi.wantstofly.org> <200803120238.49050.david-b@pacbell.net> <20080312101131.GC24017@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312101131.GC24017@xi.wantstofly.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 11:11:31AM +0100, Lennert Buytenhek wrote:

> > > Seems like EHCI IRQ firing while ehci_iaa_watchdog() is running.
> > 
> > Does RC5 resolve this?
> 
> Nope.
> 
> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 (post -rc5) looks like it
> might fix it -- I'll re-test with that applied as well.

It seems to be looking somewhat better so far with -rc5 plus
e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 -- I haven't run into the
oops yet.
