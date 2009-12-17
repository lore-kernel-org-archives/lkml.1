Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbZLPX7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbZLPX7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761723AbZLPX7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:59:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761610AbZLPX7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:59:31 -0500
Message-ID: <4B2974F0.1030505@novell.com>
Date: Thu, 17 Dec 2009 09:01:52 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH -stable] vmalloc: conditionalize build of pcpu_get_vm_areas()
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com> <4B1E0E56.8020003@kernel.org> <4B1E1EE60200007800024364@vpn.id2.novell.com> <4B1E1513.3020000@kernel.org> <4B203614.1010907@novell.com> <20091216231210.GB9421@kroah.com>
In-Reply-To: <20091216231210.GB9421@kroah.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On 12/17/2009 08:12 AM, Greg KH wrote:
>> Please note that this commit won't appear on upstream.
> 
> So this is only needed for the .32 kernel stable tree?  Not .31?  And
> it's not upstream as it was solved differently there?

Yeap, .32 is the only affected one and in the upstream the problem is
solved way back and ia64 is already using the new dynamic allocator.

Thanks.

-- 
tejun
