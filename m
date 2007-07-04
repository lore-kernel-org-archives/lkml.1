Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbXGDQQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbXGDQQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXGDQQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:16:07 -0400
Received: from ns.suse.de ([195.135.220.2]:48378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbXGDQQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:16:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: make SMP locks handling interact properly =?iso-8859-1?q?with=09CONFIG=5FDEBUG=5FRODATA?= (2nd try)
Date: Wed, 4 Jul 2007 18:15:58 +0200
User-Agent: KMail/1.9.6
Cc: Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
References: <468B5B54.76E4.0078.0@novell.com> <468BBFB3.9080303@goop.org>
In-Reply-To: <468BBFB3.9080303@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707041815.58923.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007 17:41:39 Jeremy Fitzhardinge wrote:
> Jan Beulich wrote:
> > Instead of suppressing the change of .text to become readonly, make
> > the SMP locks patching code properly adjust/restore the page access
> > rights.
> >   
> 
> I guess we'll need to do the same thing for paravirt_ops patching?

Not if the patching happens early enough at boot. That's true for Xen
and lguest, but I'm not sure about VMI

-Andi

