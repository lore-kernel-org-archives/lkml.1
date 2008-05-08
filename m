Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYEHTHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYEHTHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbYEHTHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:07:00 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52478 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYEHTG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:06:59 -0400
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>,
       Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0805081951570.21297@blonde.site>
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
	 <1210272164.7905.66.camel@nimitz.home.sr71.net>
	 <Pine.LNX.4.64.0805081951570.21297@blonde.site>
Content-Type: text/plain
Date: Thu, 08 May 2008 12:06:53 -0700
Message-Id: <1210273613.7905.69.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 19:58 +0100, Hugh Dickins wrote:
> But it's
> simply wrong for a "generic" pagewalker to be going blindly in there.
> 
> Two good examples in the same file??

I was just noting that the other two pagewalking users did the right
vm_huge..() check, and we missed it in the third pagewalker user.

-- Dave

