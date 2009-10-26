Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZJZPpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZJZPpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZJZPpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:45:45 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:1401 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZJZPpo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Mon, 26 Oct 2009 11:45:44 -0400
Message-Id: <4AE5D238020000780001BD46@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 26 Oct 2009 15:45:44 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Yinghai Lu" <yinghai@kernel.org>, <tglx@linutronix.de>,
       "Takashi Iwai" <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent
	 allocations
References: <4AE06644020000780001B4AD@vpn.id2.novell.com>
 <20091023114825.GH5886@elte.hu>
 <4AE5CA8C020000780001BD09@vpn.id2.novell.com>
 <20091026152246.GB3749@elte.hu>
In-Reply-To: <20091026152246.GB3749@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 26.10.09 16:22 >>>
>* Jan Beulich <JBeulich@novell.com> wrote:
>> And any attempt to eliminate the conditional another way would just 
>> introduce a very similar conditional elsewhere; with this having a 
>> single user (and foreseeably not ever a second one) I would think this 
>> would just make the code less readable.
>
>There's 3 other current uses of DMA_BIT_MASK(24) in arch/x86 - couldnt 
>those use ISA_DMA_BIT_MASK too?

Oh, so you didn't mean me to eliminate the conditional in pci-dma.c, but
just to replace the DMA_BIT_MASK(24) here an elsewhere. Sure, I'm fine
with adding this to the patch.

Jan

