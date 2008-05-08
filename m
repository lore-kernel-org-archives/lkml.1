Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbYEHUI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbYEHUI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYEHUIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:08:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33018 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYEHUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:08:35 -0400
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1210276153.7018.90.camel@calx>
References: <Pine.LNX.4.64.0805062043580.11647@blonde.site>
	 <20080506202201.GB12654@escobedo.amd.com>
	 <1210106579.4747.51.camel@nimitz.home.sr71.net>
	 <20080508143453.GE12654@escobedo.amd.com>
	 <1210258350.7905.45.camel@nimitz.home.sr71.net>
	 <20080508151145.GG12654@escobedo.amd.com>
	 <1210261882.7905.49.camel@nimitz.home.sr71.net>
	 <20080508161925.GH12654@escobedo.amd.com>
	 <20080508163352.GN23990@us.ibm.com>
	 <20080508165111.GI12654@escobedo.amd.com>
	 <20080508171657.GO23990@us.ibm.com>
	 <Pine.LNX.4.64.0805081914210.16611@blonde.site>
	 <1210276153.7018.90.camel@calx>
Content-Type: text/plain
Date: Thu, 08 May 2008 13:08:17 -0700
Message-Id: <1210277297.7905.74.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 14:49 -0500, Matt Mackall wrote:
> I'd gone to some lengths to pull VMAs out of the picture as it's quite
> ugly to have to simultaneously walk VMAs and pagetables. But I may have
> to concede that living with hugepages requires it.

Yeah, it will definitely change the way that we have to do the pagetable
walk.

Should we just pass the mm around and make anyone that really wants to
get the VMAs do the lookup themselves?  Or, should we just provide the
VMA?

I'll start with just the mm and see where it goes...

-- Dave

