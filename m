Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYI0A7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYI0A7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 20:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYI0A7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 20:59:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:16370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYI0A7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 20:59:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,317,1220252400"; 
   d="scan'208";a="444180760"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "akataria@vmware.com" <akataria@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Date: Fri, 26 Sep 2008 17:59:06 -0700
Subject: RE: Use CPUID to communicate with the hypervisor.
Thread-Topic: Use CPUID to communicate with the hypervisor.
Thread-Index: AckgOQbxvfJ/5QnsR6awInrO2A+gzwAABbEg
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A15718417A@orsmsx505.amr.corp.intel.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48DD799C.3070706@zytor.com> <1222475403.29886.57.camel@alok-dev1>
 <48DD7F1A.4060703@zytor.com>
In-Reply-To: <48DD7F1A.4060703@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m8R0xUdq018199

On 9/26/2008 5:32:26 PM, H. Peter Anvin wrote:
> Alok Kataria wrote:
> > > >
> > > This is great, obviously... although we'll have to deal with
> > > legacy methods for a while if not indefinitely (just as we have to
> > > for pre-CPUID processors).
> >
> > Ok, do you think we should keep those (legacy) interfaces separate
> > so that they can be phased out whenever the time is right.
> >
>
> I don't, realistically, think we can phase them out for a very long
> time, and then it's usually a "why bother".  What we want to do is
> abstract them so they don't make the rest of the code suck.
>
> >
> > I would like to see this as a generic hypervisor way to get
> > frequency rather than a VMware specific thingy.
> > > In order for *that* to be safe, you'd have to have well-defined
> > > ranges for different virtualization vendors where each of them can
> > > define their own stuff.
> >
> > My motivation for doing this is to have a standard across all the
> > hypervisor's. If all the different hypervisor guys can come to some
> > sought of consensus on the various hypervisor leafs that would help
> > keep this simple and a lot more maintainable.
> >
>
> Agreed.  However, that's obviously beyond our immediate control.

Well, actually it's under full control of the Linux community because the _kernel_ defines such virtual or semi-hardware features. I'm not sure if that particular value (0x40000010) is proper, but we should be able to pick reasonable ones/ranges.

>
>         -hpa
             .
Jun Nakajima | Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
