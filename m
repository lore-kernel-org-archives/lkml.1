Return-Path: <linux-kernel-owner+w=401wt.eu-S1763842AbYEITMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763842AbYEITMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYEITLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:11:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:35799 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbYEITLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Jrsk9wthRyl+C8T4fKQa5mIL8pO8EMAU6psCIwqN0Ymqp76e6dUceU/x+suIxIe4S/L2YX2YbemIPh2v+0aXKyLRhfyXL1oawP6oozXWsngXnCQUe9NYBAUiaQCVjr/NPmM1fOXtu2bLXKKbbLz+Y10MB9shGAEaU1Ldl8sYYqo=
Date: Sat, 10 May 2008 00:07:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Chris Snook <csnook@redhat.com>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Luca Tettamanti <kronos.it@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       torvalds@osdl.org
Subject: Re: atl1 64-bit => 32-bit DMA borkage (reproducible, bisected)
Message-ID: <20080509200715.GA5040@martell.zuzino.mipt.ru>
References: <20080420060607.2b1be48b@osprey.hogchain.net> <20080420122631.GA4761@martell.zuzino.mipt.ru> <20080420133704.63f5cc10@osprey.hogchain.net> <20080420205500.GA4762@martell.zuzino.mipt.ru> <20080421210821.28053a92@osprey.hogchain.net> <20080425195743.2bfe66ee@osprey.hogchain.net> <20080504211507.GC1040@martell.zuzino.mipt.ru> <20080506110225.31fd61a4@osprey.hogchain.net> <20080509195149.GA4985@martell.zuzino.mipt.ru> <48249E55.1020300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48249E55.1020300@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 02:56:21PM -0400, Chris Snook wrote:
> Alexey Dobriyan wrote:
>> Hmmm, there was a wonderful oops on interface stop here when the other end
>> of atl1 cable was physically unplugged (but there was traffic before):
>> 	atl1_down
>> 	atl1_clean_rx_ring
>> 	swiotlb_unmap_single
>> 	swiotlb_unmap_single_attrs
>> 	memcpy_c
>
> Intel chip, or AMD?

Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz
Asus P5B-E motherboard.

