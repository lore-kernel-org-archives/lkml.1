Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXLAAGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXLAAGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbXLAAFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:05:47 -0500
Received: from namei.org ([69.55.235.186]:49216 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754631AbXLAAFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:05:46 -0500
Date: Sat, 1 Dec 2007 11:05:41 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Crispin Cowan <crispin@crispincowan.com>
cc: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: Out of tree module using LSM
In-Reply-To: <4750A225.3060505@crispincowan.com>
Message-ID: <Xine.LNX.4.64.0712011052480.24380@us.intercode.com.au>
References: <47507818.8010808@crispincowan.com> <Xine.LNX.4.64.0712010824170.5027@us.intercode.com.au>
 <4750A225.3060505@crispincowan.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Crispin Cowan wrote:

> > The only case of this so far has been Multiadm, although there seems to be 
> > no reason for it to stay out of tree.
> >   
> Dazuko. It has the same yucky code issues as Talpa, but AFAIK is pure
> GPL2 and thus is clean on the license issues.
>
> That these modules are valid modules that users want to use, are GPL
> clean, and are *not* something LKML wants to upstream because of code
> issues, is precisely why the LSM interface makes sense.

I think the idea is to try and fix code quality issues through 
participation in the upstream process, rather than have upstream maintain 
stable kernel APIs which are naturally mismatched to the unknown 
requirements of out of tree users.

- James
-- 
James Morris 
<jmorris@namei.org>

