Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZETNw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZETNw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZETNwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:52:17 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:27384
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752563AbZETNwQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:52:16 -0400
X-BigFish: VPS-14(zz1432R1805Mzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KJY3US-01-C5O-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD SVM
Date: Wed, 20 May 2009 08:52:10 -0500
Message-ID: <6453C3CB8E2B3646B0D020C11261327303620967@sausexmb4.amd.com>
In-Reply-To: <1242810616.26820.562.camel@twins>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD SVM
Thread-Index: AcnZKtulfNVaMWC9TeSs4bqaKYNqvQAJx9JA
References: <200905050909.58583.mark.langsdorf@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <200905081203.55484.mark.langsdorf@amd.com> <200905191356.37071.mark.langsdorf@amd.com> <1242806386.26820.549.camel@twins>  <4A13C199.5020400@redhat.com> <1242808954.26820.556.camel@twins>  <4A13C40B.8080608@redhat.com> <1242809657.26820.559.camel@twins>  <4A13C7B0.10507@redhat.com> <1242810616.26820.562.camel@twins>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Peter Zijlstra" <peterz@infradead.org>, "Avi Kivity" <avi@redhat.com>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 May 2009 13:52:10.0824 (UTC) FILETIME=[2C299C80:01C9D952]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Once we go change silicon, you might as well do it right.
> > >   
> > 
> > None of the major x86 vendors are under my control.
> 
> I thought this patch came from AMD, who changed their silicon 
> so 'solve' one of these virt problems.

Right, and the change we came up with was to provide
a method for filtering PAUSEs and then intercepting
after a certain number.

It may not be the solution you wanted, but I can't
change the silicon design that has the feature at 
this point.

-Mark Langsdorf
Operating System Research Center
AMD

