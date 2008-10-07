Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYJGPSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYJGPSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYJGPS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:18:27 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:33024 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752662AbYJGPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:18:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=e2cQjDfkpxxUKEaKmZroC+Xy1W4wbwpiaVm4cZGt2FL1x9UNpXy1MVH5pUV+4Bs5Z3cVgVZvW0v5vxz6Iq33E6dJzIWjcC5PKMPeGBXLcWcj+QgaQwxGm/hvb5NBKmhZBrzCBuFUARxMAAl5KapCG/C9+8oYc0S/hSAGV6E+ACw=  ;
X-YMail-OSG: dEW8A20VM1m81Tv7P4b_1NUDSalJzpG7IQ41c9zCbXNK33wXXNBC_S9bEwdos6Ml.Hd5uP2io5OXPGTvk.YJhYJAiWb0rx6DCGjO3eaeCy7Mf5OURIjz.kUhcIlYRv0jsiOigdv.g7PtMmLKrzQMcjMbZXfKbPc2Q2icxx0X7f63I3FMCSI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11224] Only three cores found on quad-core machine.
Date: Wed, 8 Oct 2008 02:18:18 +1100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Jones" <davej@redhat.com>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.xUB.2875IB@wind>
In-Reply-To: <yWwteD.A.xUB.2875IB@wind>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080218.18898.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2008 04:32, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
> Subject		: Only three cores found on quad-core machine.
> Submitter	: Dave Jones <davej@redhat.com>
> Date		: 2008-08-01 18:15 (65 days old)
> References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4

Dave, is your CPU2 getting stuck in calibrate_delay? Can you still
reproduce the bug? What if you boot the kernel with lpj=<something sane
like 2666785> in order to skip the calibrate_delay code?

If that helps, can you try adding some printks to narrow down where it
is getting stuck?
