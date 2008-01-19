Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbYAST2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbYAST2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYAST1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:27:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYAST1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:27:52 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [7/8] CPA: Implement GBpages support in change_page_attr()
Date: Sat, 19 Jan 2008 20:27:46 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080119748.170864000@suse.de> <20080119064835.A68D614EAD@wotan.suse.de> <20080119185314.GB3751@elte.hu>
In-Reply-To: <20080119185314.GB3751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801192027.46689.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 19:53:14 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> >  arch/x86/mm/pageattr_64.c | 150 
> >  ++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 119 insertions(+), 31 deletions(-)
> 
> please unify the files first, we dont want to let pageattr_32.c and 
> pageattr_64.c diverge even more. Once we get these files unified we 
> layer more features ontop of it. 

They work significantly differently in a few important areas (e.g. particularly 
regarding NX  handling and the kernel mapping) Off the top of my 
head I don't know of a clean way to unify them. 32bit and 64bit kernel 
mappings differ in many significant ways. Maybe it's possible, but it's 
certainly not something I would want to tackle short term in a hurry.
The kernel mappings between 32bit and 64bit are quite different.

However I would like GBPAGES definitely to make the .25 merge window
and they won't work without the upgraded c_p_a().

So please reconsider.

> While gbpages is not available on  
> 32-bit and probably wont ever be, this code has been historically very 
> fragile, 

I'm sure a hurried up unification would make it even more fragile.

-Andi
