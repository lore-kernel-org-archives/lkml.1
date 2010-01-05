Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452Ab0AEI5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0AEI5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201Ab0AEI5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:57:48 -0500
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:35157 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab0AEI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:57:47 -0500
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Date:From:To:Cc:Subject:Message-ID:
   References:Mime-Version:Content-Type:Content-Disposition:
   In-Reply-To;
  b=MSRGlrrDUeIKb3G6xdAByYzXeZAWZHExZxLT2FCVH2R0sWjkS3r7XUgM
   lyMiEk0kaFbKirp68QjN6o/UwpypBMyw14e0HplMnz8WKQsjUdR7H/jrx
   xp9DJP2kinAmsF+bFCRIioa2SKmw/ABAJARZ2CaY5r4OdBvpmE6DUNTEk
   wEhq8f6Hqch1MgIZXK7Hu5npIaZfdHn+ekvU/O12Ztznfa+I/yq1cvoup
   d27gbxTrsBCcui2A+Y2/NTNiuY5BL;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.47,504,1257116400"; 
   d="scan'208";a="14670876"
X-IronPort-AV: E=Sophos;i="4.47,504,1257116400"; 
   d="scan'208";a="84153510"
Date: Tue, 5 Jan 2010 09:57:43 +0100
From: Andreas Friedrich <andreas.friedrich@ts.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Wolfgang Erig <Wolfgang.Erig@ts.fujitsu.com>
Subject: Re: [Bug #14902] Boot ends not on tty1
Message-ID: <20100105085743.GA13491@upset.ux.pdb.fsc.net>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.WjB.MwhOLB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <srmJ8vMxKPH.A.WjB.MwhOLB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Di, Dez 29, 2009 at 04:28:54 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).

the problem was gone after the latest Debian lenny and etch upgrades
(one of libexpat1, libltdl3, libpq4/5 does the fix). I think that the 
kernel change which came with e11c675ede0d42a405ae595528bf0b29ce1ae56f
is now supported in Debian, so it is no longer a kernel issue.

Please remove the error from the regression list.

Thanks,
Andreas

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14902
> Subject		: Boot ends not on tty1
> Submitter	: Andreas Friedrich <andreas.friedrich@ts.fujitsu.com>
> Date		: 2009-12-15 8:05 (15 days old)
> References	: http://marc.info/?l=linux-kernel&m=126086495304263&w=4
