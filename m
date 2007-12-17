Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbXLQNw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbXLQNw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXLQNwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:52:50 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:49383
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbXLQNwu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:52:50 -0500
Message-Id: <47668D71.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 17 Dec 2007 13:53:37 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <olaf@aepfle.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: also define AT_VECTOR_SIZE_ARCH
References: <475D6C91.76E4.0078.0@novell.com>
 <20071217134235.GI1870@elte.hu>
In-Reply-To: <20071217134235.GI1870@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 17.12.07 14:42 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> The patch introducing this left out x86-64, despite it also having 
>> extra entries.
>
>thanks, applied. Is there any 2.6.24 urgency for this?

While I haven't seen x86-64 to break due to this (it appears that 32-bit
apps would be more susceptible), I know that we had major problems
with the respective piece missing from the 32-bit Xen kernels in openSuSE
10.3, so I would strongly suggest putting this into .24.

Jan

