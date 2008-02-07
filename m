Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYBGI4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYBGI4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYBGI4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:56:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:3106 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYBGI4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:56:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c5H+GdWNaQzRa8kiuRGi3AScavOfqnqH6RFLgqNS0PD1Fvj43DCGH3xTgGOqxxIVrgM5NVaVSlQ4eG6WIcbW0Dy/EXJuPCJzgxUR3DotFfmi2/p4W0Gd838UIF9wzacd983jASTehsR4oE9IFX1oSUGT7I5cuLMqFxsDyeqH/YY=
Message-ID: <86802c440802070056o215e97b0u945a08b12dca8d2@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:56:06 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb mtrrs - FIX
Cc: "Balaji Rao" <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, jesse.barnes@intel.com,
       ak@suse.de
In-Reply-To: <20080207080245.GA28631@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802071257.51893.balajirrao@gmail.com>
	 <20080207080245.GA28631@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Balaji Rao <balajirrao@gmail.com> wrote:
>
> > Hello,
> >
> > The following commit caused my X server to stop working.
> >
> > commit 99fc8d424bc5d803fe92cad56c068fe64e73747a
> > Author: Jesse Barnes <jesse.barnes@intel.com>
> > Date:   Wed Jan 30 13:33:18 2008 +0100
> >
> >     x86, 32-bit: trim memory not covered by wb mtrrs
> >
> > This patch fixes the improper handling of addresses > 4G by
> > mtrr_trim_uncached_memory. This, now brings up X on my system.
>
> thanks. Incidentally this same bug was reported and fixed yesterday, and
> that fix is upstream already. Could you please compare your solution to
> Yinghai Lu's fix below, and send us a patch for any further improvements
> (or cleanups) you might notice in that code? It seems to be almost the
> same fix as yours. (and hopefully it fixes your X problem too)

then title for patch is not right
> >     x86, 32-bit: trim memory not covered by wb mtrrs

should be

x86_64: trim memory not covered by wb mtrrs

anyway, we can not modify git log in linux-2.6.git. can we?

YH
