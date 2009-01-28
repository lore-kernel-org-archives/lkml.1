Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbZA1TWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbZA1TWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZA1TWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:22:38 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:61723 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZA1TWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:22:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hoWxhArJ9T7tkElSEfWXYFYJtuT+jCoud5sQ8GEkCzP6g6BH2MtUzXe/dNu7B04or5
         iurrcCs/d9MHrQ/PkMYC+uAUNRk/nu1ArFwzs1Ik9KEDCX+p6nrajdGxwnfxTyGvhTdG
         q5nKo4xrII+nUid6x2hYkHaUNOCS2kg0r6R1o=
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <49809A65.2090501@kernel.org>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
	 <1233106614.3256.6.camel@localhost.localdomain>
	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 11:22:12 -0800
Message-Id: <1233170532.6717.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 09:48 -0800, H. Peter Anvin wrote:
> Arnd Bergmann wrote:
> > 
> > For the specific x86 swab code, that would certainly be the simplest
> > way, user space should not be using those inline assemblies either
> > way.
> > 
> > I think the more interesting question is whether we want to export
> > *any* inline helpers that are not part of the ABI to user space.
> > We already killed most of them (spinlocks, atomics, ...) and what
> > remains is basically just the byteorder code. All that is required
> > for the ABI is the information whether the system is big- or
> > little-endian, but not all the rest.
> > 
> 
> In general, no.  The byteswap API is a legacy exception.
> 

But now that swab.h has been separated out, we could just stop exporting the
asm/swab.h bits while still providing a generic C-based implementation to
userspace.

Harvey


