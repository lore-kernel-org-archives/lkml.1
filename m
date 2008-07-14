Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbYGNJXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbYGNJXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYGNJXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:23:24 -0400
Received: from ns.suse.de ([195.135.220.2]:37626 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYGNJXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:23:24 -0400
Date: Mon, 14 Jul 2008 11:24:04 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Vivek Goyal" <vgoyal@redhat.com>, kexec@lists.infradead.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation
 automatically
Message-ID: <20080714112404.36783df5@halley.suse.de>
In-Reply-To: <86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	<20080627133256.GB5801@redhat.com>
	<86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu [2008-07-14 00:11]:
>
> should use min_t(u64, 1ULL<<32, max_low_pfn<<PAGE_SHIFT) replace ULONG_MAX

Shouldn't we use  min_t(u64, ULLONG_MAX, max_low_pfn<<PAGE_SHIFT), i.e.
should we really limit the crashkernel to a 32 bit address on a 64 bit
system?



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
