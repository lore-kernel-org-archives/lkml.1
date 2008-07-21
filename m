Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYGUPS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYGUPS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYGUPRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:17:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:38782 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbYGUPRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RVMFb2nd2sp6iM9dyj3tPMm+dOGBNm7lABlo+7tiw16EMZFNJgdExNXasSDKI1gs/n
         T1m1Pt+TpMHfySbPRg7wpPkZb8AGQLMsRicbVdWylW+l3y9xJA8C0ta24BSSxXQUfdeh
         hS5CxPUK3SFI4bQRf1ygCiAhds2ipOS9rA0vY=
Date: Mon, 21 Jul 2008 19:15:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daniel Kubiak <sor@czlug.icis.pcz.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux based router Kernel Panic (2.6.23 - 2.6.26-rc9)
Message-ID: <20080721151559.GA12604@martell.zuzino.mipt.ru>
References: <48849FA7.9060604@czlug.icis.pcz.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48849FA7.9060604@czlug.icis.pcz.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 04:39:35PM +0200, Daniel Kubiak wrote:
> I've got Linux based router (Intel Xeon 3060 + Intel S3200SH ServerBoard 
> with 2x1GbE NIC) which make NAT and QoS for 2000+ computers. Usually past 
> 4-8 days of uptime I've got Kernel Panic. I try 2.6.23-2.6.26-rc9 kernels). 
> Here is photo of Kernel Panic: http://www.sor.osiris.czest.pl/dsc02009.jpg

Enable CONFIG_KALLSYMS and CONFIG_DEBUG_BUGVERBOSE next time.

Or you can grab vmlinux of that kernel and decipher addresses by hand.

