Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbXKISl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbXKISl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbXKISlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:41:03 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:50232 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbXKISlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:41:00 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Fri, 9 Nov 2007 19:36:02 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071109183602.GD1988@alberich.amd.com>
References: <11943900793940-git-send-email-sam@ravnborg.org>
 <20071106230451.GA10886@uranus.ravnborg.org>
MIME-Version: 1.0
In-Reply-To: <20071106230451.GA10886@uranus.ravnborg.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Nov 2007 18:35:42.0444 (UTC)
 FILETIME=[556052C0:01C822FF]
X-WSS-ID: 6B2A770807S2030204-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 12:04:51AM +0100, Sam Ravnborg wrote:
> This serie of patches unify the X86 Kconfig files.
> Next step is to enable use of "make ARCH=x86" and kill
> "make ARCH=i386/x86_64".
> But that will wait till tomorrow.
> 
> The allmodconfig kernel is still building here.
> Testing / reviews appreciated.
> 
> Comments from former patchset is addressed - see
> changelog entries.

Just some kind of feedback wrt your patch set.
I did several hundred randconfig kernel compiles based
on 2.6.24-rc2 with your patches on top plus those additional
minor fixes mentioned on lkml.

>From what I've seen there were no compile failures that seem
to be caused by your adaptations.

Mostly I have seen the ususal suspects (e.g. missing firmware and
lots of failed configs due to conflicting types for net_free 
- AFAIK that is already solved in netdev tree - and due to the
"kvm-smp_call_function-issue").

The rest (5 failed configs) was not specific to x86 but driver
related (e.g. v4l).


Regards,

Andreas

PS: Looking forward to test the ARCH=x86 enabled kbuild.
BTW, what is the right git tree to pull this stuff from?
Is it your x86.git tree? But that one is not up to date, is it?

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



