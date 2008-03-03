Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYCCSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYCCSLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758921AbYCCSKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:10:23 -0500
Received: from gw.goop.org ([64.81.55.164]:58681 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYCCSKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:10:22 -0500
Message-ID: <47CC3DE5.4060105@goop.org>
Date: Mon, 03 Mar 2008 10:05:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA support
 - alternatives"
References: <47C86D7A.5030608@goop.org> <20080303173057.GA14598@Krystal> <47CC3C2B.6000807@goop.org> <200803031903.35724.ak@suse.de>
In-Reply-To: <200803031903.35724.ak@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Monday 03 March 2008 18:58:03 Jeremy Fitzhardinge wrote:
>
>   
>> Perhaps, though that's uncached by default.
>>     
>
> ioremap_cached()

Sure.  But given that from the perspective of this problem ioremap* is 
just a wrapper for vmap, we may as well use it directly and avoid 
getting tangled up in any current or future io-related stuff that 
ioremap may want to do.

    J
