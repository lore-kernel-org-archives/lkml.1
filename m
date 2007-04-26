Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbXDZOLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbXDZOLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbXDZOLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:11:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:36227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbXDZOLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:11:46 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mel Gorman <mel@skynet.ie>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error
Date: Thu, 26 Apr 2007 16:11:28 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4630980D.7010904@shadowen.org> <20070426132736.GA16909@skynet.ie>
In-Reply-To: <20070426132736.GA16909@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261611.29121.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 15:27:36 Mel Gorman wrote:
> On (26/04/07 13:16), Andy Whitcroft didst pronounce:
> > Getting the following on an x86_64 numa box:
> > 
> >   CC      arch/x86_64/vdso/vclock_gettime.o
> > arch/x86_64/vdso/vclock_gettime.c:1: error: code model `small' not
> > supported in the 32 bit mode

32bit mode?  Something must be confused.

What gcc/binutils is that?

Can you post V=1 output for that line please?

It works for me with gcc 4.1 and 3.3

-Andi
