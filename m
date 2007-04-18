Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbXDRGM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbXDRGM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbXDRGM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:12:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45695 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbXDRGM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:12:56 -0400
Date: Wed, 18 Apr 2007 09:12:54 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Dave Hansen <hansendc@us.ibm.com>
cc: Pavel Emelianov <xemul@sw.ru>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Linux MM <linux-mm@kvack.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M (v2)
In-Reply-To: <1176831473.12599.30.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0704180912130.11014@sbz-30.cs.Helsinki.FI>
References: <4624E8F4.2090200@sw.ru> <1176831473.12599.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 19:34 +0400, Pavel Emelianov wrote:
> > +#define SHOW_TOP_SLABS 10 

On Tue, 17 Apr 2007, Dave Hansen wrote:
> Real minor nit on this one: SHOW_TOP_SLABS sounds like a bool.  "Should
> I show the top slabs?"
> 
> This might be a bit more clear:
> 
> #define TOP_NR_SLABS_TO_SHOW 10 
> 
> or
> 
> #define NR_SLABS_TO_SHOW 10

Yes. Looks much better.

				Pekka
