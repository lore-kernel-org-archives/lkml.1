Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbYDZWgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYDZWgE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 18:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYDZWfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 18:35:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56007 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbYDZWfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 18:35:53 -0400
Date: Sat, 26 Apr 2008 23:24:33 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Ingo Molnar <mingo@elte.hu>
cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] x86: create array based interface to chagne page
 attribute
In-Reply-To: <20080426141718.GA10936@elte.hu>
Message-ID: <alpine.DEB.0.82.0804262323520.26860@skynet.skynet.ie>
References: <1209202037-6513-1-git-send-email-airlied@redhat.com>
 <20080426095115.GA15212@elte.hu> <20080426141718.GA10936@elte.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-34269702-1209248673=:26860"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-34269702-1209248673=:26860
Content-Type: TEXT/PLAIN; charset=US-ASCII


> 
> [    0.120007] CPU: Processor Core ID: 0
> [    0.124007] ACPI: Core revision 20070126
> [    0.128008] BUG: unable to handle kernel paging request at fffffffb80d6fe30
> [    0.128008] IP: [<ffffffff802200a3>] __change_page_attr_set_clr+0x6c/0xaf7
> [    0.128008] PGD 203067 PUD 0
> [    0.128008] Thread overran stack or stack corrupted
> 
>   http://redhat.com/~mingo/misc/log-Sat_Apr_26_15_47_59_CEST_2008.bad
>   http://redhat.com/~mingo/misc/config-Sat_Apr_26_15_47_59_CEST_2008.bad
> 
> 	Ingo

Doh.... BPB time...

one-liner attached.

Dave.
--29444707-34269702-1209248673=:26860
Content-Type: TEXT/x-diff; charset=US-ASCII; name=x.diff
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.82.0804262324330.26860@skynet.skynet.ie>
Content-Description: 
Content-Disposition: attachment; filename=x.diff

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL3BhZ2VhdHRyLmMgYi9hcmNoL3g4
Ni9tbS9wYWdlYXR0ci5jDQppbmRleCBlZTE2YjFiLi5jN2ZlODc2IDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYvbW0vcGFnZWF0dHIuYw0KKysrIGIvYXJjaC94
ODYvbW0vcGFnZWF0dHIuYw0KQEAgLTczMCw3ICs3MzAsNyBAQCBzdGF0aWMg
aW50IF9fY2hhbmdlX3BhZ2VfYXR0cl9zZXRfY2xyKHN0cnVjdCBjcGFfZGF0
YSAqY3BhLCBpbnQgY2hlY2thbGlhcykNCiAJCWlmIChjcGEtPmFycmF5KQ0K
IAkJCWNwYS0+Y3VyYWRkcisrOw0KIAkJZWxzZQ0KLQkJCWNwYS0+dmFkZHIg
Kz0gY3BhLT5udW1wYWdlcyAqIFBBR0VfU0laRTsNCisJCQkqY3BhLT52YWRk
ciArPSBjcGEtPm51bXBhZ2VzICogUEFHRV9TSVpFOw0KIAl9DQogCXJldHVy
biAwOw0KIH0NCg==

--29444707-34269702-1209248673=:26860--
