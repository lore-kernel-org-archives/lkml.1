Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbYDVPem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbYDVPem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYDVPeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:34:07 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:44338 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYDVPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aPlpuH+8yTKOtVC8hmpmmceV/oVLb8gVA88vH7bDn3NgjL/CrEz+WEScUrlC3Ia6/fG4a3YgKEeWW0tgtFRPGheqRaS+AG3lR68HbcfN6ui750D735FP4kYwkXaCaR/PEQ9G6seJTUO1oyC7RLGjTWyhDdz804+uxhHETFXnInA=
Message-ID: <87a5b0800804220834q4d6daec1x4146d211115ab5c@mail.gmail.com>
Date: Tue, 22 Apr 2008 16:34:03 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <20080422152426.GG19802@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
	 <20080422081211.e85989ec.randy.dunlap@oracle.com>
	 <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com>
	 <20080422152426.GG19802@phobos.i.cabal.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 4:24 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
> On Tue, Apr 22, 2008 at 04:16:17PM +0100, Will Newton wrote:
>  > It can be done with Kconfig. Whether it should be or not depends on
>  > your point of view, hence RFC. Currently __ARCH_WANT macros is the way
>  > syscalls are enabled and disabled across architectures. If there's
>  > consensus that it should be done via Kconfig that could certainly be
>  > implmented, but that's a different patch.
>  >
>
>  It's currently done in unistd.h for hysterical raisins. All new
>  conditional syscalls have been done in Kconfig.

Do you have a syscall in mind that does this in the correct way?

BTW, don't blame the blackfin guys for this, I'm thinking about future
architectures that may be added rather than any existing ones. ;-)
