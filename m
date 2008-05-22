Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYEVQtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYEVQtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYEVQt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:49:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42709 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYEVQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:49:25 -0400
Message-ID: <4835A3EC.1030307@zytor.com>
Date: Thu, 22 May 2008 09:48:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Add recent Centaur CPUs to PAT whitelist
References: <200805200409.m4K49V3G024332@gelk.kernelslacker.org> <86802c440805192249y77e78918u8392f5a43331365@mail.gmail.com> <20080520131943.GA4843@redhat.com> <4834B6AC.9090503@zytor.com> <20080522140753.GB20613@redhat.com>
In-Reply-To: <20080522140753.GB20613@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, May 21, 2008 at 04:56:28PM -0700, H. Peter Anvin wrote:
>  > Dave Jones wrote:
>  > > 
>  > > From conversation with Centaur engineers, both the newer generations
>  > > of the VIA C7, and their future CPUs support PAT, with no known errata.
>  > > 
>  > > Signed-off-by: Dave Jones <davej@redhat.com>
>  > > 
>  > 
>  > Question: are there any VIA CPUs that display the PAT CPUID flag that 
>  > aren't covered by the above?
> 
> No.  They only added PAT support with the current Esther (C7) generation iirc.
> 

OK, so we should just enable VIA unconditionally as long as PAT is 
displayed and not worry about generation numbers; same with Transmeta 
(only the Transmeta Efficeon supported PAT, and it had a 
strictly-coherent memory system.)

	-hpa
