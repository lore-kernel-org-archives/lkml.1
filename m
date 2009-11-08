Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZKHR2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZKHR2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbZKHR2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:28:04 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:58960 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZKHR2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:28:03 -0500
Date: Sun, 8 Nov 2009 17:28:05 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       x86team <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86,apic: Use PAGE_SIZE instead of numbers
In-Reply-To: <20091108155356.GB25940@lenovo>
Message-ID: <alpine.LFD.2.00.0911081726350.9725@eddie.linux-mips.org>
References: <20091108155356.GB25940@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009, Cyrill Gorcunov wrote:

> The whole page is reserved for IO-APIC fixmap
> due to non-cacheable requirement. So lets note
> this explicitly instead of playing with numbers.
> 
> CC: Yinghai Lu <yinghai@kernel.org>
> CC: "Maciej W. Rozycki" <macro@linux-mips.org>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Is PAGE_SIZE still always 4kB for the x86 these days?  If so, then your 
change makes sense to me.

  Maciej
