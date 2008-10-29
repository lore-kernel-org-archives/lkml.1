Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYJ2VeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYJ2VeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYJ2Vd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:33:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42706 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbYJ2Vd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:33:56 -0400
Date: Wed, 29 Oct 2008 17:32:44 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: bob.montgomery@hp.com, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] disable CPU side GART accesses
Message-ID: <20081029213244.GD24794@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Airlie <airlied@gmail.com>, bob.montgomery@hp.com,
	Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"vojtech@suse.cz" <vojtech@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"chandru@in.ibm.com" <chandru@in.ibm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@linux.intel.com>
References: <1224107317.2215.238.camel@amd.troyhebe> <20081015234842.GA10999@elte.hu> <1225147341.2215.401.camel@amd.troyhebe> <4906495B.1060506@kernel.org> <1225313564.3428.14.camel@amd.troyhebe> <21d7e9970810291424g369035d4h562b54c676d49aef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970810291424g369035d4h562b54c676d49aef@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 07:24:34AM +1000, Dave Airlie wrote:

 > This stops the CPU from using the aperture for most DRI things. I
 > can't confirm this won't regress working systems
 > though. The whole AMD GART thing scares me, esp if some of the host
 > chipsets also have an AGP GART.

The easy cop-out for those in the past has been 'dont support them'.
It's why we removed some K8 chipset PCI IDs from the via driver for eg.
iirc, if we leave them unprogrammed, they're essentially irrelevant.

	Dave

-- 
http://www.codemonkey.org.uk
