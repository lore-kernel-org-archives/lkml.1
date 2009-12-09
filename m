Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZLISZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZLISZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZLISZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:25:48 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:32928 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbZLISZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:25:47 -0500
Date: Wed, 9 Dec 2009 12:24:55 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mike Travis <travis@sgi.com>
cc: tony.luck@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
In-Reply-To: <alpine.DEB.2.00.0912091218060.16491@router.home>
Message-ID: <alpine.DEB.2.00.0912091224061.16491@router.home>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com> <alpine.DEB.2.00.0912091128280.16491@router.home> <4B1FE81F.30408@sgi.com>
 <alpine.DEB.2.00.0912091218060.16491@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Christoph Lameter wrote:

> Boot with 2.6.32 and see if the per cpu allocator works. Check if there
> are any changes to memory consumption. Create a few thousand virtual
> ethernet devices and see if the system keels over.

Argh. You have to wait till 2.6.33-rc1 I believe to get the conversion of
the SNMP MIBs for the new per cpu allocator.

