Return-Path: <linux-kernel-owner+w=401wt.eu-S1946057AbXDEH4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946057AbXDEH4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946059AbXDEH4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:56:24 -0400
Received: from sghqmaxdr.chevron.com ([203.127.203.102]:14950 "EHLO
	sghqmaxdr.chevron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946057AbXDEH4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:56:23 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 03:56:22 EDT
X-IronPort-AV: i="4.14,374,1170604800"; 
   d="scan'208"; a="963218:sNHT31496297"
X-CVX-Departure: Verified
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [patch 1/2] Relocate VDSO ELF headers to match mapped	location with COMPAT_VDSO
Date: Thu, 5 Apr 2007 14:45:56 +0700
Message-ID: <8646EB4D6B054F4E8AB083CA829C4C810107364E@iddrintx1.iddri.chevrontexaco.net>
In-Reply-To: <4614A5DA.9050700@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/2] Relocate VDSO ELF headers to match mapped	location with COMPAT_VDSO
Thread-Index: Acd3VPd2d1PEdr1sSf+kK4jysxWqsgAAQlkQ
References: <20070405045825.511024444@goop.org> <20070405045843.333498131@goop.org> <4614BD10.76E4.0078.0@novell.com> <4614A5DA.9050700@goop.org>
From: "Raharjo, Cahyo \(cahr\)" <Cahyo.Raharjo@chevron.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jan Beulich" <jbeulich@novell.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       <virtualization@lists.osdl.org>, "Roland McGrath" <roland@redhat.com>,
       "Andi Kleen" <ak@suse.de>, "lkml" <linux-kernel@vger.kernel.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
X-OriginalArrivalTime: 05 Apr 2007 07:45:58.0810 (UTC) FILETIME=[734457A0:01C77756]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,
In this few days, I got emails from this list. I tried to exclude thru
majordomo, but it failed.
Kindly need your help to exclude me from this list.


Thank You, 
CR


-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jeremy
Fitzhardinge
Sent: Thursday, April 05, 2007 2:32 PM
To: Jan Beulich
Cc: Ingo Molnar; Andrew Morton; virtualization@lists.osdl.org; Roland
McGrath; Andi Kleen; lkml; Zachary Amsden; Eric W. Biederman
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped
location with COMPAT_VDSO

Jan Beulich wrote:
> While there's a certain level of control on what DT_* may appear in 
> the vDSO, not even considering other than the above types seems 
> fragile to me. Since future additions to the set are supposedly 
> following a fixed scheme (distinguishing pointers and values via the 
> low bit when below OLD_DT_LOOS, and using sub-ranges when between 
> DT_HIOS and OLD_DT_HIOS), at least also handling those would seem like

> a good idea, as would warning about unrecognized types.
>   

I wasn't aware of this scheme.  Where is it documented?

> Also, even though it shouldn't matter for the final result, if doing 
> things spec-conforming here you should use d_un.d_ptr.
>   

Yes, I've already fixed that.

> In addition to Roland's remarks about missing symbol table relocation,

> I would also assume section headers, if present, should be relocated.
>   

Yes, I suppose that's easy enough to add.

    J
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in the body of a message to majordomo@vger.kernel.org More majordomo
info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
