Return-Path: <linux-kernel-owner+w=401wt.eu-S1030457AbXAaRkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbXAaRkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030458AbXAaRke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:40:34 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53813 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457AbXAaRkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:40:33 -0500
Date: Wed, 31 Jan 2007 12:40:21 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Andi Kleen <ak@suse.de>
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH] x86_64: Fix preprocessor condition
Message-ID: <20070131174021.GA17747@filer.fsl.cs.sunysb.edu>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <11702634681921-git-send-email-jsipek@cs.sunysb.edu> <200701311816.02372.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701311816.02372.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 06:16:02PM +0100, Andi Kleen wrote:
> 
> > -#if defined(__KERNEL__) && __x86_64__
> > +#if defined(__KERNEL__) && defined(__x86_64__)
> 
> Undefined symbols are replaced with 0, so the old line was already ok.

Fair enough, however sparse is not very happy about underfined symbols.

Jeff.

-- 
Reality is merely an illusion, albeit a very persistent one.
		- Albert Einstein
