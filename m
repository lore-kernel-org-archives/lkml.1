Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYJOKGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYJOKGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYJOKGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:06:08 -0400
Received: from outbound-mail-157.bluehost.com ([67.222.39.37]:38722 "HELO
	outbound-mail-157.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750880AbYJOKGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:06:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=XMJw+iTsbnsfHTRkg10E24Vu4spvFpC3fcsxqc3RzYwrVcuPmYCxCE4t8b7j0znb4h3k4ZMcCQxgWONt9frsFmrmAHTap6HT1gvjFknC1jFfVE4YCbngRzRUKSqRhodO;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [patch] fix 64-vbit prefetchable memory resource BARs
Date: Wed, 15 Oct 2008 03:05:25 -0700
User-Agent: KMail/1.9.10
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <8763nx1fr3.wl%peter@chubb.wattle.id.au>
In-Reply-To: <8763nx1fr3.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810150305.25258.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 90.152.48.188 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 12, 2008 5:49 pm Peter Chubb wrote:
> Since patch 6ac665c63dcac8fcec534a1d224ecbb8b867ad59
> my infiniband controller hasn't worked.  This is because it has
> 64-bit prefetchable memory, which was mistakenly being  taken to be
> 32-bit memory.  The resource flags in this case are
> PCI_BASE_ADDRESS_MEM_TYPE_64|PCI_BASE_ADDRESS_MEM_PREFETCH.
>
> This patch checks only for the PCI_BASE_ADDRESS_MEM_TYPE_64 bit; thus
> whether the region is prefetchable or not is ignored.  This fixes my
> Infiniband.
>
>
> Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>

Applied to my linux-next branch, thanks.  I'll be sending to Linus soon 
(hopefully today).

Thanks,
Jesse
