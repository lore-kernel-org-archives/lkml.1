Return-Path: <linux-kernel-owner+w=401wt.eu-S1763822AbYCGNWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763822AbYCGNWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYCGNW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:22:26 -0500
Received: from mga05.intel.com ([192.55.52.89]:40403 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753623AbYCGNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:22:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,462,1199692800"; 
   d="scan'208";a="530312910"
Message-ID: <47D1412C.50404@linux.intel.com>
Date: Fri, 07 Mar 2008 07:20:44 -0600
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Hellwig <hch@infradead.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
References: <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org> <20080304014306.GC28006@linux-os.sc.intel.com> <20080304103220.GA17621@elte.hu> <20080304175528.GD28006@linux-os.sc.intel.com> <20080305194705.GA4386@ucw.cz> <20080306155141.GA23340@elte.hu> <20080306202446.GA4225@ucw.cz> <47D1352F.6010504@zytor.com> <47D13DEF.6030006@linux.intel.com> <20080307131841.GE7365@one.firstfloor.org>
In-Reply-To: <20080307131841.GE7365@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> this is just for handling the case where that fails
>> (basically near/totally OOM or the case where you get a fatal signal)
> 
> I didn't think GFP_KERNEL was interruptible by signals...
> (although sometimes under oom thrashing I think it would be great if it was...) 

we need to make it (or with GFP_KILLABLE); would make total sense...
(so yeah it was more wishful thinking than reality)
