Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbYJTIeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbYJTIeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYJTIeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:34:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:59778 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYJTIeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:34:08 -0400
Subject: Re: [PATCH 1/2] Implement %pR to print struct resource content
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20081020070631.GA12131@elte.hu>
References: <20081020040820.C1882DDDEA@ozlabs.org>
	 <20081020070631.GA12131@elte.hu>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 19:33:14 +1100
Message-Id: <1224491594.7654.132.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 09:06 +0200, Ingo Molnar wrote:
> 
> > + * - 'R' For a struct resource pointer, it prints the range of
> > + *       addresses (not the name nor the flags)
> 
> > +     case 'R':
> > +             return resource_string(buf, end, ptr, field_width, precision, flags);
> 
> small dtail: could you please also add the information that this is 
> about the kernel-special resource_size_t integer type? That type is used 
> more widely than just struct resource.
> 

I'm not sure I understand ? It's a "struct resource" pointer, which is
what I wrote :-)

Cheers,
Ben.


