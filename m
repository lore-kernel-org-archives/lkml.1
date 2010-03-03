Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab0CCA0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:26:55 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:34945 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754723Ab0CCA0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:26:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=V84aGPiPVXXo2S3ky28gHXvZBaBX5w3u/L8VtbUBuSjLAtgkvCd1FP9HI1awZQx4hrNgk+axMlrCQaFfXjzxOCaq3gsXt0T2404XRUqXN9MYu88Mgrndd+WZUkNoAjIj;
Date: Tue, 2 Mar 2010 16:26:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] Avoid implicit constant truncation
Message-ID: <20100302162649.055c998b@jbarnes-piketon>
In-Reply-To: <4B8DA809.1040205@xenotime.net>
References: <1267574468-7609-1-git-send-email-imunsie@au.ibm.com>
	<4B8DA809.1040205@xenotime.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Mar 2010 16:06:33 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 03/02/10 16:01, imunsie@au1.ibm.com wrote:
> > From: Ian Munsie <imunsie@au.ibm.com>
> > 
> > When building on 64 bit platforms, the compiler throws the following
> > warning:
> > 
> > drivers/pci/probe.c:197: warning: large integer implicitly
> > truncated to unsigned type
> > 
> > This patch adds an explicit truncation to silence the compiler
> > warning.
> 
> 
> Please see/read/use Documentation/SubmittingPatches.  E.g.:
> 
> The canonical patch subject line is:
> 
>     Subject: [PATCH 001/123] subsystem: summary phrase
> 
> I.e., the subject: should tell us that this is a PCI: patch.
> 
> (or even pci: -- i don't care which)

No need to resubmit though; I usually have to fix up the summary and
changelog a bit when applying anyway.

That said, this patch rings a bell; I think the warning is signalling a
real bug in the ppc code.  IIRC Ben was going to look at it awhile
back, but I think it's mostly harmless so it's probably low on his list.

-- 
Jesse Barnes, Intel Open Source Technology Center
