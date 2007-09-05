Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbXIEQNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbXIEQNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbXIEQN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:13:29 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:32391 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756462AbXIEQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:13:28 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 5 Sep 2007 18:13:00 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Arne Georg Gleditsch" <argggh@dolphinics.no>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070905161300.GE22086@alberich.amd.com>
References: <20070903081736.288288000@amd.com>
 <20070903081736.588599000@amd.com>
 <20070903013157.72c94891@laptopd505.fenrus.org>
 <20070903091718.GB22144@alberich.amd.com>
 <20070903043319.7573875b@laptopd505.fenrus.org>
 <20070903154734.GC22086@alberich.amd.com> <46DE45A2.40403@zytor.com>
 <20070905084427.GE6409@erda.amd.com> <46DE80F0.4000706@zytor.com>
 <kjmd4wxz822.fsf@pelargir.dolphinics.no>
MIME-Version: 1.0
In-Reply-To: <kjmd4wxz822.fsf@pelargir.dolphinics.no>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Sep 2007 16:12:57.0949 (UTC)
 FILETIME=[9FB058D0:01C7EFD7]
X-WSS-ID: 6AC00A061A46708606-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 01:05:25PM +0200, Arne Georg Gleditsch wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> > You're missing the point.   How will the PCI bus transactions be
> > different when using MMCONFIG versus your extended CF8 version?
> 
> Conceivably this is useful if the IO hub does not support MMCONFIG
> accesses.  The AMD 8111 does not, as far as I can see.  At least I
> have an Opteron system where MMCONFIG is not supported, and I assume
> it's because the 8111 doesn't provide it.  I don't know if this is
> going to be a realistic scenario for Barcelona systems.
> 
> -- 
> 								Arne.

Not sure how many AMD 8111 based systems are out there which are
upgradeable to Barcelona.

I guess the BIOS won't setup MCFG for systems with 8111/8131 
because both lack ECS MMIO Base Address Register. 
(Because 8111 and 8131 are not Mode2-PCI-X and PCI-express
capable.)

So if such a board is upgradeable, the way to access extended
config space of the northbridge functions is to use CF8/CFC
ECS access.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



