Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbZKDRni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbZKDRni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbZKDRnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:43:35 -0500
Received: from outbound-mail-146.bluehost.com ([67.222.38.36]:40591 "HELO
	outbound-mail-146.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757579AbZKDRnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:43:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PHJ/W+8mpaTEWXlj7Tt0y+4c+9SQSVgDVIwJqUG2gq/zf+RxXtQ+IaRJHrBZSXlcJhPsjP9ANIuLZxqXYV6OHpbo2FbTJIfWD0Y0osxB5kcbX9QA2dz6UgR6Rq6M5iFZ;
Date: Wed, 4 Nov 2009 09:43:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] vsprintf: use %pR, %pr instead of %pRt, %pRf
Message-ID: <20091104094335.31247fe2@jbarnes-piketon>
In-Reply-To: <20091027192647.12712.36043.stgit@bob.kio>
References: <20091027192647.12712.36043.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 13:26:47 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Jesse accidentally applied v1 [1] of the patchset instead of v2 [2].
> This is the diff between v1 and v2.
> 
> The changes in this patch are:
>     - tidied vsprintf stack buffer to shrink and compute size more
>       accurately
>     - use %pR for decoding and %pr for "raw" (with type and flags)
> instead of adding %pRt and %pRf
> 
> [1] http://lkml.org/lkml/2009/10/6/491
> [2] http://lkml.org/lkml/2009/10/13/441
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
