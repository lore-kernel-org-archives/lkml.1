Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZKHRgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZKHRgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZKHRgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:36:47 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:64956 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZKHRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:36:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AoMZv3JyOX0PZf78IrLuiX52BM5NnyfI10RDldojSfvXh8WgnLbEcU6zWywnhnTU3j
         qqvUkJzIbWfY3YQW+zHgxoKRbB8m/Yw42L3+V+mf4+CV2yJmou5ES+Ik+tVuqk1rDR6n
         0PF0jigvAUfkF+AxVmKMQEf1alxcBl+j1a/O0=
Date: Sun, 8 Nov 2009 20:36:50 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       x86team <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86,apic: Use PAGE_SIZE instead of numbers
Message-ID: <20091108173650.GF25940@lenovo>
References: <20091108155356.GB25940@lenovo> <alpine.LFD.2.00.0911081726350.9725@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911081726350.9725@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sun, Nov 08, 2009 at 05:28:05PM +0000]
| On Sun, 8 Nov 2009, Cyrill Gorcunov wrote:
| 
| > The whole page is reserved for IO-APIC fixmap
| > due to non-cacheable requirement. So lets note
| > this explicitly instead of playing with numbers.
| > 
| > CC: Yinghai Lu <yinghai@kernel.org>
| > CC: "Maciej W. Rozycki" <macro@linux-mips.org>
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > ---
| 
| Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
| 
|  Is PAGE_SIZE still always 4kB for the x86 these days?  If so, then your 
| change makes sense to me.

Yeah, as far as I know. I didn't find any sign if we going to
change PAGE_SHIFT.

| 
|   Maciej
| 
	-- Cyrill
