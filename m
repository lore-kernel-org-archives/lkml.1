Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYL2N3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYL2N3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYL2N25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:28:57 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:58360 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbYL2N2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j1GJsjDwrKNVkuh3SfilcLplTbsZmZrkqts9VPvcg24EyW/3MfCeCkSnSYVWU4x3FV
         pYJ2qBH6pAu35OPbZ9dAAs+IEyiJfWqdIu94tL/LmjytxiqAx98+FhHZlg6XUcfqpf7M
         2Xw3wjNZJ/hPdGScEQFREkhA+zmtAkBH/qLG4=
Date: Mon, 29 Dec 2008 08:28:39 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Rusty Russell <rusty@fandango2.ozlabs.ibm.com>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc: fix compile damage from 2a4aca11
Message-ID: <20081229132839.GA20987@zod.rchland.ibm.com>
References: <200812291711.26118.rusty@fandango2.ozlabs.ibm.com> <1230533237.15389.43.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230533237.15389.43.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 05:47:17PM +1100, Benjamin Herrenschmidt wrote:
>On Mon, 2008-12-29 at 17:41 +1100, Rusty Russell wrote:
>> In file included from /scratch/kisskb/src/arch/powerpc/mm/mem.c:51:
>> /scratch/kisskb/src/arch/powerpc/mm/mmu_decl.h: In function
>> '_tlbil_all':
>> /scratch/kisskb/src/arch/powerpc/mm/mmu_decl.h:34: error: expected ';'
>> before '}' token
>> /scratch/kisskb/src/arch/powerpc/mm/mmu_decl.h:36: error: invalid
>> storage class for function '_tlbil_pid'
>> 
>> "powerpc/mm: Split low level tlb invalidate for nohash processors" needs
>> more semicolons.  Or testing.  Or both.
>
>Yeah, looks like both paulus and I are missing 40x and 8xx test configs
>in our build tests :-( I'll fix that.,

Argh.  I have that fixed locally because I needed it during my testing.
Seems I never actually reported the problem.  Sorry.  I blame testing
new patches the day before vacation starts.

josh
